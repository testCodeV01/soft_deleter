require "test_helper"

class SoftDeleterTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert SoftDeleter::VERSION
  end
end
