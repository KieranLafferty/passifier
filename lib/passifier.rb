#!/usr/bin/env ruby

# libs
require "forwardable"
require "json"
require "net/http"
require "zip/zip"

# modules
require "passifier/signing"

# classes
require "passifier/archive"
require "passifier/manifest"
require "passifier/manifest_signature"
require "passifier/pass"
require "passifier/spec"
require "passifier/static_file"
require "passifier/storage"
require "passifier/url_source"

module Passifier

  VERSION = "0.0.3"

end
