require 'helper'

class TestStaticFile < Test::Unit::TestCase

  def test_name
    file = new_static_file

    assert_equal "background.png", file.name
  end

  def test_path
    file = new_static_file

    assert_equal "test/assets/background.png", file.path
  end

  def test_content
    file = new_static_file
    size = File.size(file.path)

    assert !size.zero?
    assert_equal size, file.content.size
  end

  def new_static_file
    Passifier::StaticFile.new("background.png", "test/assets/background.png")
  end

end
