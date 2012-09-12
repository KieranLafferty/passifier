require 'helper'

class TestManifestSignature < Test::Unit::TestCase

  def test_content
    manifest_signature = Helper.new_manifest_signature

    assert_not_nil manifest_signature
    assert_not_nil manifest_signature.content
    assert_equal "sign of the timez", manifest_signature.content
  end

end
