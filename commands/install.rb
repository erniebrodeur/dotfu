command 'install' do
  banner "Install a dotfiles from Github into your home directory."

  run do |opts, args|
    unless args.any?
      puts 'install what?'
      exit 1
    end

    args.each do |target|
      repo = Dotfu::Repos.new target

      puts "Fetching repo #{target}"
      puts repo.fetch[1]
      puts "Installing #{target} to #{repo.target_directory}"
      repo.install
    end
  end
end

