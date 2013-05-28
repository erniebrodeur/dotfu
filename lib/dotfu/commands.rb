module Dotfu
  module Commands
    extend self

    def fetch(opts = nil, args = nil)
      return nil if !args

      args.each do |a|
        pairs = Dotfu.process_word a
        puts "Fetching #{a}"
        puts Dotfu::Git.fetch pairs[0], pairs[1]
        puts "Fetched #{a}"
      end
    end
    def list(opts = nil, args = nil)
      username = Dotfu::Git.config_user
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

