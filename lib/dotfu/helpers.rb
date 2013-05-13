module Dotfu
  extend self
  def available_dotfiles(username)
    results = Dotfu::GITHUB.repos.list(user:username).select {|r| r.name.start_with? 'dotfiles' };
    return nil if !results
    results.map {|r| r.name}
  end

  def is_cached?(username, dotfile)
    # this needs work, since it doesn't check for an actual healthy git repo.
    return true if Dir.exists?(dotfile_dir dotfile)
    false
  end

  def is_installed?(username, dotfile)
    # when it's available, call cache on something.
    return false if !is_cached?(username, dotfile)

    # Grab our list of files, see if they are installed.
    results = process_dotfiles(dotfile).each.map {|f| File.symlink? f[1] }

    return false if results.include? false
    return true
  end

  # Process a cached directory to get a hash of installed/uninstalled files.
  def process_dotfiles(dotfile)
    repo_files(dotfile).map do |f|
      [f, "#{Dir.home}/#{f}"]
    end
  end

  def repo_files(dotfile)
    Dir.glob("#{dotfile_dir dotfile}**/*").map do |filename|
      "#{filename.split("#{dotfile_dir dotfile}/")[1]}"
    end
  end

  # till I make bini do this
  def data_dir
    "#{Dir.home}/.local/share/dotfu"
  end

  def dotfile_dir(dotfile)
    "#{data_dir}/repos/dotfiles-#{dotfile}"
  end

  # File helpers

end
