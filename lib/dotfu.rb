require 'open3'
require 'yajl'
require 'bini'
require 'bini/config'
require 'bini/optparser'
require 'bini/sash'
require 'github_api'

require "dotfu/version"
require "dotfu/repos"

module Dotfu
  extend self

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

  def commands
    spec = Gem::Specification.find_by_name("dotfu")
    return Dir["#{spec.full_gem_path}/commands/*"]
  end
  Bini.long_name = "dotfu"
  GITHUB ||= Github.new user_agent:"Dotfu: #{Dotfu::VERSION}", auto_pagination:true
end




