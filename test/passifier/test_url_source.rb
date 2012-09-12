require 'helper'

class TestUrlSource < Test::Unit::TestCase

  TEST_URL = "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg"

  def test_name
    image = Helper.new_url_source

    assert_equal "background.png", image.name
  end

  def test_path
    image = Helper.new_url_source

    assert_equal TEST_URL, image.url
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


