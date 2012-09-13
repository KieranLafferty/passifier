# Passifier

Generate Apple Passbook passes in Ruby

Passifier does most of the hard work and will more easily allow you to automate generating pkpass files. You simply supply
  
* A Hash of metadata and layout (the contents of pass.json for those experienced)
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

First, supply a bunch of pass information and styling.  This will become the file pass.json within the pass archive.  More information on pass.json and creating a layout can be found at [developers.apple.com](https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Reference/PassKit_Bundle/Chapters/Introduction.html).

```ruby

serial = "SO_SERIAL"

spec = {
  "formatVersion" => 1,
  "passTypeIdentifier" => "pass.example.example",
  "teamIdentifier" => "ATEAMID",
  "relevantDate" => "2012-07-30T14:19Z",          
  "organizationName" => "Example Inc.",
  "serialNumber" => serial,
  "description" => "this is a pass",
  "labelColor" => "rgb(122, 16, 38)",
  "backgroundColor" => "rgb(227, 227, 227)",
  "foregroundColor" => "rgb(110,110,110)",
  "generic" => {
    "headerFields" => [
      {
        "key" => "date",
        "label" => "Date",
        "value" => "October 30th"
      }
    ],
    "primaryFields" => [
      {
        "key" => "title",
        "label" => "",
        "value" => "Passifier!"
      }
    ],
    "secondaryFields" => [
      {
        "key" => "host",
        "label" => "Host",
        "value" => "paperlesspost.com",
      }
    ]
  }
}
```

### Images

Specify a Hash of images. Notice that you can use either paths or urls here.

```ruby

images = {
  "background.png" => "assets/background.png",
  "background@2x.png" => "assets/background@2x.png",
  "icon.png" => "assets/icon.png",
  "icon@2x.png" => "assets/icon@2x.png",
  "logo.png" => "http://i.imgur.com/WLUf6.png",
  "logo@2x.png" => "http://i.imgur.com/mOpQo.png",
  "thumbnail.png" => "assets/thumbnail.png",
  "thumbnail@2x.png" => "assets/thumbnail@2x.png"
}
```

### Signing

Give Passifier some info about your .pem files.  

(to-do: more info on obtaining certificates and creating pem files)

```ruby
key_pem = "path/to/a/key.pem"
pass_phrase = "somethingsomething"
cert_pem = "path/to/a/certificate.pem"

# Create the signing
signing = Passifier::Signing.new(key_pem, pass_phrase, cert_pem)
```

### Generate!

Now it's time to create your pass!

```ruby
Passifier::Pass.create_archive("readme.pkpass", serial, spec, images, signing)
```

Passifier will have created the file `readme.pkpass` for you.  When opened in Passbook, that pass looks something like:

![image](http://i.imgur.com/fooaB.jpg)

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
