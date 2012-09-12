require 'helper'

class TestStaticFile < Test::Unit::TestCase

  def test_name
    file = Helper.new_static_file

    assert_equal "background.png", file.name
  end

  def test_path
    file = Helper.new_static_file

    assert_equal "test/assets/background.png", file.path
  end

  def test_content
    file = Helper.new_static_file
    size = File.size(file.path)

    assert !size.zero?
    assert_equal size, file.content.size
  end

end
