module Dotfu
  class Repos
    attr_accessor :repo
    attr_accessor :user
    attr_accessor :config_file
    attr_accessor :working_dir


    # r can be either a repo, or a user:repo pair.
    def initialize(arg = nil)
      self.repo = process_arg arg if arg
    end

    ### Specialized attribute methods

    # return a config_file (if overriden) or the default of 'dotfu.json'
    def config_file
      return @config_file ? @config_file : "dotfu.json"
    end

    # prepend repo with dotfiles- if it doesn't exist as it is set.
    def repo=(word)
      return @repo = word.start_with?('dotfiles-') ? word : "dotfiles-#{word}"
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

    def pull
      return nil if !repo || !user
      cmd = "git pull"

      pwd = Dir.pwd
      Dir.chdir working_dir
      out, err, status = Open3.capture3 cmd

      Dir.chdir pwd
      return [status, out, err]
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
      return nil unless fetched?

      return File.exist? "#{working_dir}/default.json"
    end

    # Is it installed?  no, because we can't install anything yet.
    def installed?
      return false
    end

    private
    def process_arg(word)
      result = word.gsub "@", ":"
      if result.include? ":"
        output = result.split ":"
        self.user = output[0]
        self.repo = output[1]
      else
        self.repo = result
      end
    end
  end
end



