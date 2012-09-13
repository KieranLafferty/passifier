#!/usr/bin/env ruby

module Passifier

  class Pass

    attr_reader :archive, 
      :image_files, 
      :manifest, 
      :serial_number, 
      :signature, 
      :spec

    # @param [String] serial_number An ID for this pass, used as the serial number in pass.json
    # @param [Hash] spec_hash The pass's spec (pass.json)
    # @param [Hash] images The pass's image assets
    #                      ex. { "background.png" => "https://www.google.com/images/srpr/logo3w.png", 
    #                          "thumbnail.png" => "~/thumb.png" }
    # @param [Signing] signing A valid signing
    def initialize(serial_number, spec_hash, images, signing, options = {})
      @signing = signing
      @spec = Spec.new(serial_number, spec_hash)
      @image_files = to_image_files(images)
      @manifest = Manifest.new(@image_files, signing)
      @signature = ManifestSignature.new(@manifest, signing)
    end

    # File objects that should be included in the archive
    # @return [Array<Spec, Manifest, ManifestSignature, StaticFile, UrlSource>] File objects that will appear in 
    #                                                                           this pass' archive
    def files_for_archive
      [@spec, @manifest, @signature, @image_files].flatten.compact
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
    # @param [Hash] images The pass's image assets
    #                      ex. { "background.png" => "https://www.google.com/images/srpr/logo3w.png", 
    #                          "thumbnail.png" => "~/thumb.png" }
    # @param [Signing] signing A valid signing
    # @return [Archive] The complete stored archive
    def self.create_archive(path, serial_number, spec_hash, images, signing, options = {})
      pass = new(serial_number, spec_hash, images, signing, options)
      pass.create_archive(path, options)
    end

    protected

    # Convert a list of images to Passifier file objects
    # @param [Hash] images A Hash of filenames and corresponding file paths or urls
    # @return [Array<StaticFile, UrlSource>] The resulting StaticFile and/or UrlSource objects
    def to_image_files(images)
      images.map do |filename, image| 
        klass = (image =~ /https?:\/\/[\S]+/) ? UrlSource : StaticFile
        klass.new(filename, image)
      end.flatten.compact
    end

  end

end

