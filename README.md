# thought dump:

Make a command on the cli called 'dotfiles'.

This command will interact with github to pull/push/fork/clone repo's named
dotfiles-*.

It will check your github by default to see what dotfiles you have.

Each repo on github will include a file named 'dotfiles.json'.  This file
contains the configuration directory, post install scripts, or any other info
needed to install the contents of the repo into a given dir(s).

The main command will have a series of global options that can apply to
any subcommand.

 * --name: the name of the owner of the repo (default pulled from your gitconfig)
 * --host: the host (default github) to search/interact with.

The command will have subcommands,

 * list: list all dotfiles-* directores
 * fetch: Pull down a dotfiles-<n> repo into the cache.
 * install: implies fetch, then installs dotfiles-<n> based on the dotfiles.json
 * search: search github for repo's based on <pattern>.
 * uninstall: remove the contents of a repo.
 * clean: clean unused items from the cache.
 * status: List which df repos that need to get updated.
 * update: update repos.

Install will support --branch to get a specific branch, including specific
commits.

Install/update/uninstall will support ```any``` as an argument.  This will
install everything it can by default.  It will also support a gist location
to support installing sets of dotfiles.

# Strategies:

It will pull the repo into a ~/.cache/dotfiles/n directory.  The file will look
for config.json, if none is present it will assume all files are to be linked
to root.  If one is present, it can have specific lists of file/locations and
list post install scripts as well as files in the directory to ignore.

It will backup along the way.  Likely to ~/.dotfiles/backups, but I may check
if XDG has some comment on backup directories.

It will cache everything possible.  This is so you can testdrive different
dotfiles quickly.  Simply install a new one, if you don't like it, install the
old one and it will relink your files to the previous one.

It will support some sort of meta-group/structured install.  This can be
achieved with full dependency support, but that's a lot of work.  This could be
done cheaply with gists (serving as ordered lists of dotfiles to install).  I'm
unsure if the work/effort is worth the reward on this one.

It will support both files and directories, the repo structure will be flat by
default but can be overridden based on the dotfiles.json.

-> /df-repo/
  - dotfiles.json
  - zshrc
  - zsh/
    - init.zsh
    - compdef/ruby
    - stuff

Their will be no need for sub directories.  Dotfiles and install files will not
be linked, by default everything else will be.

It will support segments.  These are small sections of files in a larger repo
that can be managed by command.

All files will be relative to the ```target_directory``` property.

# Configfile

The config file will be a json blob.  It will be named ```dotfu.json``` and
should be present at the base of the repo.

## Fields

  * target_directory
  * ignore_patterns
  * segments (see below)

# Segments

  * pre_install_script
  * post_install_script
  * routes

# Project Files

  * lib/dotfu/dotfu.rb
  * lib/dotfu/backup.rb
  * lib/dotfu/config_parser.rb
  * lib/dotfu/helpers.rb
  * lib/dotfu/cache.rb

# Dependencies

# Gh::Dotfiles

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'gh-dotfiles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gh-dotfiles

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# TODO

* Branches
* strategies, for example:

how should my tilda repo get installed?  this is a list of non-dotfiles installed into a dotfile.

Deep linking?  Shallow linking?  Dir linking?  Dot only?  Assume only the home dir gets dotted?

The last one is honestly the one I like the best.

Lots of thoughts here.
