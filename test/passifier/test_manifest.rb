require 'helper'

class TestManifest < Test::Unit::TestCase

  include Passifier

  def test_to_hash
    manifest = new_manifest

    assert_not_nil manifest
    assert_not_nil manifest.to_hash
    assert_not_empty manifest.to_hash.values
    assert_equal get_images.size, manifest.to_hash.values.size
    assert_equal 1, manifest.to_hash.values.uniq.size
    assert_equal "sha rite", manifest.to_hash.values.uniq.first
  end

  def test_content
    manifest = new_manifest

    assert_not_nil manifest
    assert_not_nil manifest.content
    assert manifest.to_hash.size > 0
  end

  protected

  # I am using a Mock here so that as few tests as possible will require valid keys and certificates
  class MockSigning

    def sha(content)
      "sha rite"
    end

  end

  def new_manifest
    Manifest.new(get_images, MockSigning.new)
  end

  def get_images
    [
      StaticFile.new("background.png", "test/assets/background.png"),
      StaticFile.new("background@2x.png", "test/assets/background@2x.png"),
      StaticFile.new("icon.png", "test/assets/icon.png"),
      StaticFile.new("icon@2x.png", "test/assets/icon@2x.png"),
      UrlSource.new("logo.png", "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg"),
      UrlSource.new("logo@2x.png", "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg"),
      StaticFile.new("thumbnail.png", "test/assets/thumbnail.png"),
      StaticFile.new("thumbnail@2x.png", "test/assets/thumbnail@2x.png")
    ]
  end

end



