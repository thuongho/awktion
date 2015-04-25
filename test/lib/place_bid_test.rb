require "test_helper"

class PlaceBidTest < MiniTest::Test
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

DatabaseCleaner.strategy = :truncation

# extend MiniTest::Test with the features below
class MiniTest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
    Timecop.return
  end
end