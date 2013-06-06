require 'spec_helper'
require 'shared_examples.rb'

describe Dotfu::Repos do
  describe "Unit like tests" do
    before (:each) do
      @repo = Dotfu::Repos.new "test"
    end
    describe "Specialized Attributes" do
      describe :backup_dir do
        include_examples "attribute override"
      end
      describe "config_file" do
        #include_examples "attribute override"
      end
      describe "target_dir" do
        it "by default, will return home"
        #include_examples "attribute override"
      end
      describe "repo=" do
        it "will convert word into dotfiles-word"
        it "will not create a repo like dotfiles-dotfiles-word"
      end
      describe "working_dir" do
        #include_examples "attribute override"
      end
      describe "user" do
        it "will return the user from .gitconfig global github.user"
      end
    end
    describe "Helpers" do
      describe "cloned?" do
        it "will return true if a clone is in the working_dir"
      end
      describe "config_file?" do
        it "will return true if a config_file is present in the repo's working dir"
      end
      describe "installed?" do
        it "will return true if all files are currently in place and linked"
      end
      describe "is_my_file?" do
        it "will return true if a linked file belongs to this repo"
      end
      describe "files" do
        it "will return a a list of files (relative to the repo)"
      end
      describe "existing_files" do
        it "will return a list of existing files"
        it "with a param of false, it will exclude anything that is a linked file of this repo"
      end
      describe "target_files" do
        it "will return a list of install locations"
      end
      describe "working_files" do
        it "will return an absolute path'd list of working files."
      end

      describe "target_file" do
        it "Given a String, it will return the target path + file"
        it "Given an Fixnum, it will return the target file based on the target_files array"
      end

      describe "working_file" do
        it "Given a string, it will return the working dir + file"
        it "Given a Fixnum it will return the working dir + file based on the working_files array"
      end
    end
    describe "Operations" do
      describe "Backup" do
        it "Will backup existing files"
        it "will not backup links that belong to this repo"
        it "will fail if it runs into files from another repo"
      end
      describe "Clone" do
        it "will clone in the current repo to the working_dir"
      end
      describe "Fetch" do
        it "will either clone or pull the repo"
      end
      describe "install" do
        it "will link the working files into the target dir"
      end
      describe "pull" do
        it "will pull and merge the current repo"
      end
      describe "restore" do
        it "will restore backup files to the target_dir"
      end
      describe "uninstall" do
        it "will remove the links from the target dir"
      end
    end
  end
end


