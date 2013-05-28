module Dotfu
  module Commands
    extend self

    def fetch(opts = nil, args = nil)
      return nil if !args

      # POC only, it still needs to check for output errors and a few other things.
      args.each do |a|
        repo = Dotfu::Repos.new a
        output = repo.fetch
        puts "Repo #{repo.repo}:\n#{output[1]}"
      end
    end

    def list(opts = nil, args = nil)
      username = Dotfu.config_user
      begin
        results = Dotfu::GITHUB.repos.list(user:username).select {|r| r.name.start_with? 'dotfiles' };
      rescue Exception => e
        puts 'nogojoe'
        return nil
      end

      if results.empty?
        puts "No suitable repositories found."
        return nil
      else
        puts "Repositories for #{username}:"
        results.each do |repo|
          puts "  #{repo.name}"
        end
      end
    end
  end
end
