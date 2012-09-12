#!/usr/bin/env ruby

module Passifier

  class Manifest

    attr_reader :content, :hash
    alias_method :to_hash, :hash

    # @param [Array<Passifier::StaticFile, Passifier::UrlSource>] images_files The image files to populate the manifest with
    # @param [Passifier::Signing] signing The signing to sign the images and generate the digests with
    def initialize(image_files, signing)
      @image_files = image_files
      populate_content(signing)
    end

    def filename
      "manifest.json"
    end

    def content
      to_hash.to_json
    end

    private

    # Convert the image files into signed SHA1 digests for use in the manifest file
    # @return [String] The resulting contents of the manifest file (aka Passifier::Manifest#content)
    def populate_content(signing)
      @hash = {}
      @image_files.each { |file| @hash[file.name] = signing.sha(file.content) }
    end

  end

end

