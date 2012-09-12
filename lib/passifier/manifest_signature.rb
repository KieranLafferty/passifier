#!/usr/bin/env ruby

module Passifier

  # Represents the signing of the manifest file aka "signature" file in the archive
  class ManifestSignature

    attr_reader :content

    # @param [Passifier::Manifest] manifest The Manifest to base the signature on
    def initialize(manifest, signing)
      @manifest = manifest
      populate_content(signing)
    end

    def filename
      "signature"
    end
    
    private

    # Sign the contents of the Manifest
    # @param [Passifier::Signing] signing The signing to use to generate the signature file
    # @return [String] The content of the manifest signature file aka "signature" in the archive
    def populate_content(signing)
      @content = signing.sign(manifest.content)
    end

  end

end


