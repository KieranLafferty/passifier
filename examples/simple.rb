#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "passifier"

# This is an example that will generate a simple pass and archive

#
# signing settings
# replace with your own paths/password
# 
key_pem = "../test/assets/signing/key/key.pem"
pass_phrase = File.read("../test/assets/signing/pass_phrase.txt").strip.lstrip
cert_pem = "../test/assets/signing/certificate/certificate.pem"

#
# now for the pass metadata and layout
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
# include some images
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

# create the signing
signing = Passifier::Signing.new(key_pem, pass_phrase, cert_pem)

output_file = "./simple.pkpass"

# create the pass and archive
pass = Passifier::Pass.new(serial, spec_hash, images, signing)
archive = pass.generate(output_file, :scratch_directory => "scratch_directory")

puts "Finished generating pass (#{output_file})"
