require_relative 'test_helper'

class TestRepos < Minitest::Test
  def setup
    @repo = Dotfu::Repos.new 'test'
  end

  def test_config_file?
    assert_equal false, @repo.config_file?
  end
end
