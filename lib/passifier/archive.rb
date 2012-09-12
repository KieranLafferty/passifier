#!/usr/bin/env ruby

module Passifier

  # Represents the .pkpass archive file for the pass.  Despite the extension, a .pkpass file is actually
  # a zip archive.
  class Archive

    extend Forwardable

    attr_reader :assets, 
                :id,
                :path

    def_delegators :assets, :[], :<<

    # @param [String] path The archive path
    # @param [String] id An ID to represent the Archive
    def initialize(path, id)
      @path = path
      @id = id
    end

    # The raw data of this archive file
    # @return [String] The raw data of this archive file
    def data
      File.open(@path, 'rb') {|file| file.read } unless @path.nil?
    end

    # Write the zip archive to disk
    # @param [Array<Object>] assets An Array of storable assets to put in the archive
    def store(assets, options = {})
      @assets = assets
      path = options[:scratch_directory] || "/tmp/passkit/#{@id}"
      storage = Storage.new(path)
      storage.remove_zip(@path) # remove existing archive if it exists
      storage << @assets
      storage.zip(@path, @assets)
    end

  end


end



