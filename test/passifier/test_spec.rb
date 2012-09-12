require 'helper'

class TestSpec < Test::Unit::TestCase

  def test_serial_number
    spec = Helper.new_spec

    assert_not_nil spec
    assert_equal Helper.serial, spec.serial_number
  end

  def test_content
    spec = Helper.new_spec

    assert_not_nil spec
    assert spec.content.size > 0
    assert_equal Helper.spec_hash.to_json, spec.content
  end

end
