require 'rubygems'
require 'bundler'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'passifier'

class Test::Unit::TestCase
end

# So that as few tests as possible will require valid keys and certificates
# only the Signing test uses the real goods
class MockSigning

  def sha(content)
    "sha rite"
  end

  def sign(content)
    "****"
  end

end

module Helper

  extend self
  include Passifier

  def serial
    "ARE YOU SERIAL"
  end

  def spec_hash
    {
      "formatVersion" => 1,
      "passTypeIdentifier" => "pass.example.example",
      "teamIdentifier" => "ATEAMID",
      "relevantDate" => "event time***",          
      "organizationName" => "Example Inc.",
      "serialNumber" => serial,
      "description" => "this is a pass",
      "generic" => {
        "headerFields" => [
          {
            "key" => "date",
            "label" => "event time***",
            "value" => "event date***"
          }
        ],
        "primaryFields" => [
          {
            "key" => "title",
            "label" => "",
            "value" => "This is the pass title!"
          }
        ],
        "secondaryFields" => [
          {
            "key" => "host",
            "label" => "Host",
            "value" => "paperlesspost.com",
            "textAlignment" => "PKTextAlignmentRight"
          }
        ]
      }
    }
  end

  def zip_path
    "test/zip.zip"
  end

  def scratch_directory
    "test/scratch_directory"
  end

  def create_archive_through_pass
    Pass.create_archive(zip_path, serial, spec_hash, new_images, MockSigning.new, :scratch_directory => scratch_directory) 
  end

  def new_archive
    Archive.new(zip_path, serial, new_image_files) 
  end

  def new_pass
    Pass.new(serial, spec_hash, new_images, MockSigning.new)
  end

  def new_spec
    Spec.new(serial, spec_hash)
  end

  def new_storage
    Storage.new(scratch_directory, new_image_files)
  end
  
  def new_manifest
    Manifest.new(new_image_files, MockSigning.new)
  end

  def new_manifest_signature
    ManifestSignature.new(new_manifest, MockSigning.new)
  end

  def new_images     
    {
      "background.png" => "test/assets/background.png",
      "background@2x.png" => "test/assets/background@2x.png",
      "icon.png" => "test/assets/icon.png",
      "icon@2x.png" => "test/assets/icon@2x.png",
      "logo.png" => "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg",
      "logo@2x.png" => "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg",
      "thumbnail.png" => "test/assets/thumbnail.png",
      "thumbnail@2x.png"=> "test/assets/thumbnail@2x.png"
    }
  end

  def new_image_files
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

  def new_url_source
    Passifier::UrlSource.new("background.png", image_url)
  end

  def new_static_file
    Passifier::StaticFile.new("background.png", "test/assets/background.png")
  end

  def image_url
    "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg"
  end

  def signing_pass_phrase
    File.read(TestSigning::PASS_PHRASE_FILE).strip.lstrip
  end

  def signing_assets_exist?
    if File.exist?(TestSigning::CERTIFICATE) && File.exist?(TestSigning::KEY) && File.exist?(TestSigning::PASS_PHRASE_FILE)
      true
    else
      warn "** Warning: Skipping Signing tests because .pem files are missing.  See test/passifier/test_signing.rb for more info. "
      false
    end
  end

end

