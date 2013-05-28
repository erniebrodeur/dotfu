require 'open3'
require 'bini'
require 'bini/config'
require 'bini/optparser'
require 'bini/sash'
require 'github_api'

require "dotfu/version"
require "dotfu/commands"
require "dotfu/repos"

module Dotfu
  extend self

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

  # what does the config say our user is?
  def config_user
    if !instance_variables.include? "@config_user"
      if installed?
        output = `git config github.user`.chomp!
        if output.empty?
          @config_user = nil
        else
          @config_user = output
        end
      end
    end

    return @config_user
  end

  # Is git installed in the system?
  def installed?
    if !@git_installed
      results = ENV["PATH"].split(":").map do |path|
        File.exist?("#{path}/git")
      end

      @git_installed = results.include? true
    end
    return @git_installed
  end

  Bini.long_name = "dotfu"
  GITHUB ||= Github.new user_agent:"Dotfu: #{Dotfu::VERSION}", auto_pagination:true
end



