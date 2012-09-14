#!/usr/bin/env ruby

module Passifier

  class Pass

    attr_reader :archive, 
      :asset_files, 
      :manifest, 
      :serial_number, 
      :signature, 
      :spec

    # @param [String] serial_number An ID for this pass, used as the serial number in pass.json
    # @param [Hash] spec_hash The pass's spec (pass.json)
    # @param [Hash] assets The pass's assets (can be local files or remote urls)
    #                      ex. { "background.png" => "https://www.google.com/images/srpr/logo3w.png", 
    #                          "thumbnail.png" => "~/thumb.png" }
    # @param [Signing] signing A valid signing
    def initialize(serial_number, spec_hash, assets, signing, options = {})
      @signing = signing
      @spec = Spec.new(serial_number, spec_hash)
      @asset_files = to_asset_files(assets)
      @manifest = Manifest.new(@asset_files, signing)
      @signature = ManifestSignature.new(@manifest, signing)
    end

    # File objects that should be included in the archive
    # @return [Array<Spec, Manifest, ManifestSignature, StaticFile, UrlSource>] File objects that will appear in 
    #                                                                           this pass' archive
    def files_for_archive
      [@spec, @manifest, @signature, @asset_files].flatten.compact
    end

    # Create the Archive file for this Pass
    # @param [String] path The desired path of the Archive
    # @return [Archive] The complete stored archive
    def create_archive(path, options = {})
      @archive = Archive.new(path, @spec.serial_number, files_for_archive)
      @archive.store(options)
      @archive
    end
    alias_method :generate, :create_archive
    alias_method :save, :create_archive

    # Convert a Time object to Apple's preferred String time format
    # @param [Time, Date, DateTime] The time object to convert to a String
    # @return [String] The converted time object in Apple's preferred format
    def self.to_apple_datetime(time_with_zone)
      time_with_zone.strftime("%Y-%m-%dT%H:%M%:z")
    end

    # Create a Pass and corresponding Archive file
    # @param [String] path The desired path of the Archive
    # @param [String] serial_number An ID for this pass, used as the serial number in pass.json
    # @param [Hash] spec_hash The pass's spec (pass.json)
    # @param [Hash] assets The pass's assets (can be local files or remote urls)
    #                      ex. { "background.png" => "https://www.google.com/images/srpr/logo3w.png", 
    #                          "thumbnail.png" => "~/thumb.png" }
    # @param [Signing] signing A valid signing
    # @return [Archive] The complete stored archive
    def self.create_archive(path, serial_number, spec_hash, assets, signing, options = {})
      pass = new(serial_number, spec_hash, assets, signing, options)
      pass.create_archive(path, options)
    end

    protected

    # Convert a list of assets sources to file objects
    # @param [Hash] assets A Hash of filenames and corresponding file paths or urls
    # @return [Array<StaticFile, UrlSource>] The resulting StaticFile and/or UrlSource objects
    def to_asset_files(assets)
      assets.map do |filename, source| 
        klass = (source =~ /https?:\/\/[\S]+/) ? UrlSource : StaticFile
        klass.new(filename, source)
      end.flatten.compact
    end

  end

end

