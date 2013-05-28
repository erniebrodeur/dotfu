module Dotfu
  class Repos
    attr_accessor :repo
    attr_accessor :user
    attr_accessor :working_dir


    def initialize(r = nil)
      @repo = repo if r
    end

    ### Specialized attribute methods

    # prepend repo with dotfiles- if it doesn't exist as it is set.
    def repo=(word)
      if word.start_with? 'dotfiles-'
        @repo = word
      else
        @repo = "dotfiles-#{word}"
      end
    end

    # return user or the user in the config file.
    def user
      return Dotfu::Git.config_user if !@user
    end

    # return the explicit directory this repo is cloned into.
    def working_dir
      return nil if !repo
      return "#{Bini.data_dir}/repos/#{repo}"
    end

    ### Work methods
    def clone
      return nil if !repo
      cmd = "git clone git://github.com/#{user}/#{repo}.git #{working_dir}"

      err, out, status = Open3.capture3 cmd
      return [status, out, err]
    end


    # A wrapper method to clone or update a repo.
    def fetch
      return nil if !repo
      if cached?
        pull
      else
        clone
      end
    end

    def pull
      return nil if !repo
      cmd = "git pull"

      pwd = Dir.pwd
      Dir.chdir working_dir
      err, out, status = Open3.capture3 cmd

      Dir.chdir pwd
      return [status, out, err]
    end

    ### Helper methods

    # I need to make this more sophisticated.  Or make a like updated? method.
    def cached?
      return nil if !repo
      return false if !working_dir
      files = Dir.glob("#{working_dir}/**/*")

      return true if files.any?
      return false
    end

    def installed?
      return false
    end
  end
end


