require 'digest'

module Dotfu
  def backup(dotfiles)
    FileUtils.mkdir_p backup_dir
    my_index = index dotfiles
    repo_files(dotfiles).each do |filename|
      filename = "#{Dir.home}/.#{filename}"
      next if !File.exists?(filename) && File.symlink?(filename)

      hex = Digest::SHA256.new.hexdigest filename

      # move file to backup dir
      unless File.exists? "#{backup_dir}/#{hex}"
        FileUtils.mv filename, "#{backup_dir}/#{hex}"
      end


      # add to index
      my_index[hex] = [] if !my_index[hex]
      my_index[hex] << filename if !my_index[hex].include? filename
    end
    my_index.save
  end

  def restore(dotfiles)
    my_index = index dotfiles
    return false if !File.exists? my_index.file

    my_index.load
    my_index.each do |hex,files|
      files.each do |file|
        if !File.symlink?(file)
          # throw an error here, something's not what we expect
          next
        end
        # this needs to do a fairly complex cross-dotfile check to see if
        # this file is used anywhere else.  I can either flatten all the
        # indexs into an index.json with each dotfile a hash.
        #
        # Or I can read each other json in the index directory and see if
        # the file is listed in it.
        #
        # Or I can make a clean command I run at the end to simply delete
        # anything that's not needed anymore.  For now lets just restore it.
        puts FileUtils.rm file, verbose:true, noop:true
        puts FileUtils.cp "#{backup_dir}/#{hex}", file, verbose:true, noop:true
      end
    end

    FileUtils.rm my_index.file
    return true
  end

  def backup_dir
    "#{data_dir}/backups"
  end

  def index(dotfiles)
    Bini::Sash.new file:"#{backup_dir}/#{dotfiles}.json", backup:true, autoload:true
  end
end
