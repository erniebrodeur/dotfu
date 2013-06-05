module Dotfu
  class Repos
    attr_accessor :repo
    attr_accessor :branch
    attr_accessor :user
    attr_accessor :config_file
    attr_accessor :working_dir
    attr_accessor :target_dir
    attr_accessor :backup_dir

    # r can be either a repo, or a user:repo pair.
    def initialize(arg = nil)
      parse_arg arg if arg
      parse_config
    end

    ### Specialized attribute methods
    def backup_dir
      return @backup_dir ? @backup_dir : "#{Bini.data_dir}/backups/#{repo}"
    end

    def config_file
      return @config_file ? @config_file : "dotfu.json"
    end

    # target_dir should always return something.
    def target_dir
      return @target_dir ? @target_dir : Dir.home
    end

    # prepend repo with dotfiles- if it doesn't exist as it is set.
    def repo=(word)
      return @repo = word.start_with?('dotfiles-') ? word : "dotfiles-#{word}"
    end

    # return the explicit directory this repo is cloned into.
    def working_dir
      return nil if !repo || !user
      return "#{Bini.data_dir}/repos/#{user}/#{repo}"
    end

    # return user or the user in the config file.
    def user
      return @user ? @user : Dotfu.config_user
    end

    ### Work methods
    def backup
      return nil if installed?
      files = existing_files false

      if files.any?
        FileUtils.mkdir_p backup_dir

        files.each do |target_file|
          working_file = target_file.split("#{target_dir}/").last
          next if is_my_file? target_file

          begin
            FileUtils.mv target_file, "#{backup_dir}/#{working_file}"
          rescue Exception => e
            puts e
            exit
            #puts raise RuntimeError.new "File move failed for: #{working_file} to #{backup_dir}/#{working_file} failed: #{e}"
          end
        end
      end

      return true
    end

    # initial clone
    def clone
      return nil if !repo || !user
      uri = "git://github.com/#{user}/#{repo}.git"
      FileUtils.mkdir_p working_dir
      return true if Git.clone(uri, repo, path:"#{Bini.data_dir}/repos/#{user}" )
    end

    # A wrapper method to clone or update a repo.
    def fetch
      return nil if !repo || !user
      if fetched?
        pull
      else
        clone
      end
    end


    def install
      r = Git.init working_dir

      result = r.checkout(@branch ? branch : "master")
      raise RuntimeError.new result unless result

      # Backup!
      if existing_files(false)
        puts "wtf, backup failed" unless backup
      end

      # And now that we are ok with everything, lets make some fucking files.
      # TODO: add deep linking (mkdir + ln_s for each target) or shallow (just the first directory)
      FileUtils.mkdir_p target_dir
      files.each {|file| FileUtils.ln_s working_file(file), target_file(file)}

      return true
    end

    def pull
      return nil if !repo || !user
      r = Git.init working_dir
      r.fetch
      #TODO: I'm confident that the implicit decleration of first here is going to muck something up for someone.  Find a way to do this explicitly.
      return r.remote.merge
    end

    # Restore files (as neccessary)
    def restore
      files = Dir.glob("#{backup_dir}/**/*")

      raise "Files in the way" if existing_files

      return true if files.empty?

      files.each do |f|
        FileUtils.mv f, target_dir
      end

      return true
    end

    def uninstall
      raise RuntimeError.new "Not installed." unless installed?

      target_files.each {|f| FileUtils.rm f}
      restore
      return true
    end

    ### Helper methods

    # I need to make this more sophisticated.  Or make a like updated? method.
    def fetched?
      return nil if !repo
      return false if !working_dir
      files = Dir.glob("#{working_dir}/**/*")

      return true if files.any?
      return false
    end

    # does it have a config file?  Must be fetched or will return nil.
    def config_file?
      return false unless fetched?

      return File.exist? "#{working_dir}/#{config_file}"
    end

    # returns true if every file is installed.  I need to make this more indepth,
    # but it will at lease ensure all files are linked to something in the working dir.
    def installed?
      results = target_files.map {|f| is_my_file?(f) }
      return false if results.include? false
      return true
    end

    # Return true if this file is linked to this repo.
    def is_my_file?(file)
      return true if File.exist?(file) && File.symlink?(file) && File.readlink(file).start_with?(working_dir)
      return false
    end

    # return an [Array] of base filenames.
    def files
      if !@files
        files = Dir.glob("#{working_dir}/*").map {|f| f.split(working_dir)[1][1..-1]}
        files.delete config_file
        @files = files
      end
      return @files
    end

    # return an array of existing files in the way.
    # Accepts a [Boolean] as the only argument, true to return files we linked (default),
    # false if we want just the files that are in the way.
    def existing_files(my_files = true)
      # I can do this in a convoluted set of if checks, of a couple readable selects.
      output = target_files.select { |f| File.exist? f }
      output.delete_if { |f| my_files && is_my_file?(f)}

      return output
    end

    # Return the target file.
    # Takes a [String] (explicit conversion) or [Array] for index lookup.
    # dot_home is a [Boolean] that will dot the target dir if it is the home
    # dir only.
    def target_file(file, dot_home = true)
      output = "#{target_dir}/"
      output += "." if dot_home && target_dir == Dir.home
      output += file_string(file)
      return output
    end

    # Return an [Array] of target files.
    def target_files
      files.map {|f| target_file f}
    end

    # return the working file.
    # Takes a [String] (explicit conversion) or [Array] for index lookup.
    def working_file(file)
      "#{working_dir}/#{file_string(file)}"
    end

    # Return an [Array] of working files.
    def working_files
      files.map {|f| working_file f}
    end

    private
    # So our input is now username@repo:branch
    # Repo is the only one required.
    def parse_arg(word)
      if word.include? "@"
        self.name,word = word.split("@")
      end

      if word.include? ":"
        self.repo, self.branch = word.split(":")
      end

      self.repo = word if !self.repo
    end

    def parse_config
      return nil unless config_file?

      content = Yajl.load open("#{working_dir}/#{config_file}")
      @target_dir = content["target_directory"].chomp("/") if content["target_directory"]
    end

    # Accepts a string or fixnum.  Returns either the string or the files[fixnum]
    # TODO: figure out a better fucking name for this.
    def file_string(file)
      return file.class == Fixnum ? files[file] : file
    end
  end
end

