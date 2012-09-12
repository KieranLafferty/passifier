require 'helper'

class TestPassifier < Test::Unit::TestCase

  def test_initialize
    assert_not_nil Passifier
    assert_equal Module, Passifier.class
  end

end
