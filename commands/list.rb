command 'list' do
  banner "List the repos of a given user."
  run do |opts, args|
    if args.any?
      username = args.first
    else
      username = Dotfu.config_user
    end

    begin
      results = Dotfu::GITHUB.repos.list(user:username).select {|r| r.name.start_with? 'dotfiles' };
    rescue Exception => e
      puts e
    end

    unless results && results.any?
      puts "No suitable repositories found."
    else
      puts "Repositories for #{username}:"
      results.each do |repo|
        puts "  #{repo.name}"
      end
    end
  end
end

