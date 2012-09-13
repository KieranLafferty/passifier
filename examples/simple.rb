#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "passifier"

# This is an example that will generate a simple pass file

# 1. Pass metadata and layout
# This is used to generate the pass.json file for the archive.
# See () for more information about pass.json usage
# 
serial = "SERIAL_NUM"
spec_hash = {
  "formatVersion" => 1,
  "passTypeIdentifier" => "pass.example.example",
  "teamIdentifier" => "AGK5BZEN3E",
  "relevantDate" => "2012-07-30T14:19Z",          
  "organizationName" => "Example Inc.",
  "serialNumber" => serial,
  "description" => "this is a pass",
  "generic" => {
    "headerFields" => [
      {
        "key" => "date",
        "label" => "",
        "value" => "July 30th"
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

#
# 2. Image assets
# notice that you can use either paths or urls here
#
images = {
  "background.png" => "assets/background.png",
  "background@2x.png" => "assets/background@2x.png",
  "icon.png" => "assets/icon.png",
  "icon@2x.png" => "assets/icon@2x.png",
  "logo.png" => "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg",
  "logo@2x.png" => "http://blog.paperlesspost.com/wp-content/uploads/2012/04/PP_2012-Logo_Registered-2.jpg",
  "thumbnail.png" => "assets/thumbnail.png",
  "thumbnail@2x.png" => "assets/thumbnail@2x.png"
}

#
# 3. Signing settings
# Replace with your own paths/password if you plan on running this example
# 
key_pem = "../test/assets/signing/key/key.pem"
pass_phrase = File.read("../test/assets/signing/pass_phrase.txt").strip.lstrip # you can just replace this with a string if you want
cert_pem = "../test/assets/signing/certificate/certificate.pem"

#
#
# Now, generate the pass!
#
#

# Create the signing
#
signing = Passifier::Signing.new(key_pem, pass_phrase, cert_pem)

# Create the pass archive
output_file = "./simple.pkpass"
Passifier::Pass.create_archive(output_file, serial, spec_hash, images, signing)

# Finished!
puts "Finished generating the pass archive: #{output_file}"
