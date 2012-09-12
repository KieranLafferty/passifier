#!/usr/bin/env ruby

module Passifier

  # Represents the .pkpass archive file for the pass.  Despite the extension, a .pkpass file is actually
  # a zip archive.
  class Archive

    attr_reader :assets, 
                :id,
                :path

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
    # @param [Hash] options The options to store an Archive with.
    # @option opts [String] :scratch_directory The directory to use for temp files while creating the archive. 
    #                                          (not to be confused with the archive path)
    def store(assets, options = {})
      @assets = assets
      path = options[:scratch_directory] || "/tmp/passkit/#{@id}"
      storage = Storage.new(path, @assets)
      storage.zip(@path)
      storage.cleanup
    end

  end

end



