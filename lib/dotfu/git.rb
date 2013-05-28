module Dotfu
  module Git
    extend self
    def clone(username, dotfiles)
      cmd = "git clone git://github.com/#{username}/#{dotfiles}.git #{Dotfu.dotfile_dir dotfiles}"

      err, out, status = Open3.capture3 cmd
      return [status, out, err]
    end

    def pull(username, dotfiles)
      cmd = "git pull"

      pwd = Dir.pwd
      Dir.chdir Dotfu.dotfile_dir dotfiles

      err, out, status = Open3.capture3 cmd
      return [status, out, err]
    end

    # put a copy of the repo into the cache
    def fetch(username, dotfiles)
      if Dotfu.is_cached? username, dotfiles
        Dotfu::Git.pull username, dotfiles
      else
        Dotfu::Git.clone username, dotfiles
      end
    end

    # what does the config say our user is?
    def config_user
      if installed?
        output = `git config github.user`.chomp!
        return output if !output.empty?
      end
      return nil
    end

    # Is git installed in the system?
    def installed?
      results = ENV["PATH"].split(":").map do |path|
        File.exist?("#{path}/git")
      end
      return results.include? true
    end
  end
end

