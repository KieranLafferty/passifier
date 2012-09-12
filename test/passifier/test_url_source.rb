require 'helper'

class TestUrlSource < Test::Unit::TestCase

  def test_name
    image = Helper.new_url_source

    assert_equal "background.png", image.name
  end

  def test_path
    image = Helper.new_url_source

    assert_equal Helper.image_url, image.url
  end

  def test_content
    image = Helper.new_url_source

    uri = URI(image.url)
    res = Net::HTTP.get_response(uri)
    size = res.body.size 

    assert !size.zero?
    assert_equal size, image.content.size
  end

end


