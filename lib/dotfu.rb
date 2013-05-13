require 'open3'
require 'bini'
require 'bini/config'
require 'bini/optparser'
require 'bini/sash'
require 'github_api'

require "dotfu/version"
require "dotfu/helpers"
require "dotfu/backup"
module Dotfu
  # put a copy of the repo into the cache
  def fetch(username, dotfiles)
    if is_cached? username, dotfiles
      git_pull username, dotfiles
    else
      git_clone username, dotfiles
    end
  end


  # install, backup along the way.
  def install(username, dotfiles)
    fetch(username, dotfiles) if !is_cached? username, dotfiles

    files = process_dotfiles(dotfiles)

    files.each do |pair|
      FileUtils.ln_s pair[0], pair[1] if File.exists? pair[0]
    end
  end

  # Remove the links, put the backups in place.
  def uninstall(username, dotfiles)
    process_dotfiles(dotfiles).each do |pair|
      puts pair
    end
  end

  # clean up the cache, by default remove anything that isn't linked.
  def clean(username = nil, dotfiles = nil)
  end

  private
  def git_clone(username, dotfiles)
    cmd = "git clone git://github.com/#{username}/dotfiles-#{dotfiles}.git #{dotfile_dir dotfiles}"

    err, out, status = Open3.capture3 cmd
    return [status, out, err]
  end

  def git_pull(username, dotfiles)
    cmd = "git pull"

    pwd = Dir.pwd
    Dir.chdir dotfile_dir dotfiles

    err, out, status = Open3.capture3 cmd
    return [status, out, err]
  end

  public
  Bini.long_name = "dotfu"
  GITHUB ||= Github.new user_agent:"Dotfu: #{Dotfu::VERSION}", auto_pagination:true

end
