# Description

Dotfu is a shell command to help all of us manage our dotfiles.  It is designed
to clone dotfiles from github and install them into your home directory in one command.

It will also allow you to manage/switch/test other peoples dotfiles on the fly.

Right now it will install/uninstall/fetch files.  It will not overwrite your current files, it will abort and let you move them.

Later backup originals, generate repo, search, ...

# Usage

Dotfu is a subcommand based cli like git.  It supplies various subcommands that do
the tasks for you. ```--help``` works, but it is rough.

## Arguments

Before we go over the commands, it is important to understand the repo format you use.
I don't know of a github uri, so we will use some shorthand like this ```user@repo:branch```.  Even if we do switch to a uri, I will leave this shorthand.

More about the fields:

 * user: optional, if it's not supplied we try the config file for github.user
 * repo: required, can be in the form of ```dotfiles-zsh``` or ```zsh```.
 * branch: optional, if you want to specify the branch to use.  Will switch on install, not fetch.

## Commands

### Currently working:

 * list: list all dotfiles-* directores
 * fetch: Pull down a dotfiles-<n> repo into the cache.
 * install: implies fetch, then installs dotfiles-<n> based on the dotfiles.json
 * uninstall: remove the contents of a repo.
 * search: search github for repo's based on <pattern>.

### Still to build

 * clean: clean unused items from the cache.
 * status: List which df repos that need to get updated.
 * update: update repos.

## Configfile

The config file will be a json blob.  It will be named ```dotfu.json``` and
should be present at the base of the repo.

## Fields

Currently only target_directory works.

  * target_directory (optional): if not your home dir, where?
  * ignore_patterns (optional): files in the repo to never install (good for readmes).
  * segments (optional): see below

# Segments

Segments are labeled selections of files in a repo to install selectively.

  * pre_install_script
  * post_install_script
  * routes

Routes are glob patterns and a target directory for them.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature-something`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature-something`)
5. Create new Pull Request
