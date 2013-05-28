command 'fetch' do
  banner "Fetch a repo into it's cache dir.\n"\
  "Usage: dotfu fetch [options] DOTFILES\n"

  run do |opts, args|
    return nil if !args

    # POC only, it still needs to check for output errors and a few other things.
    args.each do |a|
      repo = Dotfu::Repos.new a
      output = repo.fetch
      puts "Repo #{repo.repo} from: #{repo.user}:\n#{output[1]}"
    end
  end
end

