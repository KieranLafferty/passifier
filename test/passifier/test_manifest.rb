require 'helper'

class TestManifest < Test::Unit::TestCase

  include Passifier

  def test_to_hash
    manifest = Helper.new_manifest

    assert_not_nil manifest
    assert_not_nil manifest.to_hash
    assert_not_empty manifest.to_hash.values
    assert_equal Helper.new_image_files.size, manifest.to_hash.values.size
    assert_equal 1, manifest.to_hash.values.uniq.size
    assert_equal "sha rite", manifest.to_hash.values.uniq.first
  end

  def test_content
    manifest = Helper.new_manifest

    assert_not_nil manifest
    assert_not_nil manifest.content
    assert manifest.to_hash.size > 0
  end

end



