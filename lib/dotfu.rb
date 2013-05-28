require 'open3'
require 'bini'
require 'bini/config'
require 'bini/optparser'
require 'bini/sash'
require 'github_api'

require "dotfu/version"
require "dotfu/helpers"
require "dotfu/commands"
require "dotfu/git"
require "dotfu/backup"

module Dotfu
  def install(username, dotfiles)
    Dotfu::Git.fetch(username, dotfiles) if !is_cached? username, dotfiles

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

  # process various possible mini-uri's into username/dotfile pairs.
  #
  # "string"  Assume this is the repo, look up the config for user.
  # "username:string" obvious.
  # "username@string" obvious.
  #
  def process_word(word)
    result = word.gsub "@", ":"
    if result.include? ":"
      output = result.split ":"
      return output[0], to_repo(output[1])
    else
      return [Dotfu::Git.config_user, to_repo(result)]
    end
  end

  def to_repo(repo)
    return repo if repo.start_with? 'dotfiles-'
    return "dotfiles-#{repo}"
  end

  public
  Bini.long_name = "dotfu"
  GITHUB ||= Github.new user_agent:"Dotfu: #{Dotfu::VERSION}", auto_pagination:true
end
