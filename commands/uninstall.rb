command 'uninstall' do
  banner "Uninstall dotfiles from your home directory."

  run do |opts, args|
    unless args.any?
      puts 'install what?'
      exit 1
    end

    args.each do |target|
      repo = Dotfu::Repos.new target

      unless repo.installed?
        puts "#{target} is not installed."
        exit
      end
      puts "Uninstalling #{target} from #{repo.target_dir}"
      repo.uninstall
    end
    puts "Complete."
  end
end

