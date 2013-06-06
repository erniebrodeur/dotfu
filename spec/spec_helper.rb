
if ENV["COVERAGE"] == 'true'
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter
  ]
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'dotfu'

TEST_REPO = "https://github.com/erniebrodeur/dotfiles-testfor_dotfu.git"
