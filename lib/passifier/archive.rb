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
    def initialize(path, id, assets)
      @assets = assets
      @path = path
      @id = id
    end

    # The raw data of this archive file
    # @return [String] The raw data of this archive file
    def data
      File.open(@path, 'rb') {|file| file.read } unless @path.nil?
    end

    def destroy
      unless @storage.nil?
        @storage.cleanup
        @storage.remove_zip(@path)
      end
    end

    # Write the zip archive to disk
    # @param [Hash] options The options to store an Archive with.
    # @option opts [String] :scratch_directory The directory to use for temp files while creating the archive. 
    #                                          (not to be confused with the archive path)
    def store(options = {})
      scratch_dir = options[:scratch_directory] || "/tmp/passkit/#{@id}"
      @storage = Storage.new(scratch_dir, @assets)
      @storage.store
      @storage.zip(@path)
      @storage.cleanup
    end
    alias_method :save, :store

  end

end



