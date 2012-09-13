# Passifier

Generate Apple Passbook passes in Ruby

Passifier does most of the hard work and will easier allow you to automate generating pkpass files. You simply supply
  
* A Hash of metadata and layout (basically pass.json for those experienced)
* Image urls and paths
* The location of your key/certificate files
* Output path for the generated .pkpass file
  
## Installation

  gem install passifier

## Usage

Find a example [here](http://github.com/paperlesspost/passifier/blob/master/examples/simple.rb)

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
