# Passifier

Generate Apple Passbook passes in Ruby

Passifier does most of the hard work and will easier allow you to automate generating pkpass files. You simply supply
  
* A Hash of metadata and layout (basically pass.json for those experienced)
* Image urls and paths
* The location of your key/certificate files
* Output path for the generated .pkpass file
  
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'passifier'
```

## Usage

### Metadata and Layout

First, supply a bunch of pass information and styling.  This will become the file pass.json within the pass archive.  More inforomation on pass.json and creating a layout can be found at [developers.apple.com](https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Reference/PassKit_Bundle/Chapters/Introduction.html).

```ruby

serial = "SERIAL_NUM"

spec_hash = {
  "formatVersion" => 1,
  "passTypeIdentifier" => "pass.example.example",
  "teamIdentifier" => "ATEAMID",
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
```

### Images

Notice that you can use either paths or urls here

```ruby

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
```

### Signing

Give Passifier some info about your .pem files.  

(to-do: more info on obtaining certificates and creating pem files)

```ruby
key_pem = "../test/assets/signing/key/key.pem"
pass_phrase = "mypassword!"
cert_pem = "../test/assets/signing/certificate/certificate.pem"
```

### Generate!

```ruby
# Create the signing
signing = Passifier::Signing.new(key_pem, pass_phrase, cert_pem)

# Finally, create the pass archive
Passifier::Pass.create_archive("readme.pkpass", serial, spec_hash, images, signing)
```

Passifier will have created the file `readme.pkpass` for you.

Find a similar example with some more explanation [here](http://github.com/paperlesspost/passifier/blob/master/examples/simple.rb)

## Contributing to Passifier
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Create an issue in the issue tracker
* Fork the project.
* Start a feature/bugfix branch; include the issue number in the branch name.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.

## Copyright

Copyright © 2012 Paperless Post. See LICENSE.md for details.
