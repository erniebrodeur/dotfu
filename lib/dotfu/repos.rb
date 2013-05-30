module Dotfu
  class Repos
    attr_accessor :repo
    attr_accessor :user
    attr_accessor :config_file
    attr_accessor :working_dir
    attr_accessor :target_dir

    # r can be either a repo, or a user:repo pair.
    def initialize(arg = nil)
      self.repo = parse_arg arg if arg
      parse_config
    end

    ### Specialized attribute methods
    def config_file
      return @config_file ? @config_file : "dotfu.json"
    end

    # prepend repo with dotfiles- if it doesn't exist as it is set.
    def repo=(word)
      return @repo = word.start_with?('dotfiles-') ? word : "dotfiles-#{word}"
    end

    # target_dir should always return something.
    def target_dir
      return @target_dir ? @target_dir : Dir.home
    end

    # return user or the user in the config file.
    def user
      return @user ? @user : Dotfu.config_user
    end

    # return the explicit directory this repo is cloned into.
    def working_dir
      return nil if !repo || !user
      return "#{Bini.data_dir}/repos/#{user}/#{repo}"
    end

    ### Work methods

    # initial clone
    def clone
      return nil if !repo || !user
      cmd = "git clone git://github.com/#{user}/#{repo}.git #{working_dir}"

      out, err, status = Open3.capture3 cmd
      return [status, out, err]
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
      # lets check if we have anything in the way, and abort instead of partially
      # installing
      existing_files = target_files.select {|f| File.exist? f}
      raise NotImplementedError.new "File(s) exist: #{existing_files}"

      # And now that we are ok with everything, lets make some fucking files.
      # TODO: add deep linking (mkdir + ln_s for each target) or shallow (just the first directory)
      FileUtils.mkdir_p target_dir
      files.each {|file| FileUtils.ln_s file, target_file(file)}

      return true
    end

    def pull
      return nil if !repo || !user
      cmd = "git pull"

      pwd = Dir.pwd
      Dir.chdir working_dir
      out, err, status = Open3.capture3 cmd

      Dir.chdir pwd
      return [status, out, err]
    end

    def uninstall

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

    # Is it installed?  no, because we can't install anything yet.
    def installed?
      return false
    end

    # Return true if this file was installed from our repo.
    def is_my_file?(file)
      return nil unless File.exist? target_file(file_string(file))
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

    # Return the target file.
    # Takes a [String] (explicit conversion) or [Array] for index lookup.
    def target_file(file)
      "#{target_dir}/.#{file_string(file)}"
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
    def parse_arg(word)
      result = word.gsub "@", ":"
      if result.include? ":"
        output = result.split ":"
        self.user = output[0]
        self.repo = output[1]
      else
        self.repo = result
      end
    end

    def parse_config
      return nil unless config_file?

      content = Yajl.load "{\"target_dir\":\"/home/ebrodeur/Projects/gems/dotfu/tmp\"}"
      @target_dir = content["target_dir"] if content["target_dir"]
    end

    # Accepts a string or fixnum.  Returns either the string or the files[fixnum]
    # TODO: figure out a better fucking name for this.
    def file_string(file)
      return file.class == Fixnum ? files[file] : file
    end
  end
end


