require 'helper'

class TestSigning < Test::Unit::TestCase

  include Passifier

  # You must have the following three files for these tests to run.
  #
  CERTIFICATE = "test/assets/signing/certificate/certificate.pem"
  KEY = "test/assets/signing/key/key.pem"

  # The password file is just a text file containing the password.
  PASS_PHRASE_FILE = "test/assets/signing/pass_phrase.txt"

  if Helper.signing_assets_exist?

    def test_initialize
      signing = Signing.new(KEY, Helper.signing_pass_phrase, CERTIFICATE)

      assert_not_nil signing
    end

    def test_sign
      signing = Signing.new(KEY, Helper.signing_pass_phrase, CERTIFICATE)
      assert_nothing_raised do
        signed = signing.sign("hello!")

        assert_not_nil signed
      end
    end

    def test_sha
      signing = Signing.new(KEY, Helper.signing_pass_phrase, CERTIFICATE)
      assert_nothing_raised do 
        sha = signing.sha("hi")

        assert_not_nil sha
        assert_equal 40, sha.size
      end
    end

  end

end



