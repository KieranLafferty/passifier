#!/usr/bin/env ruby

module Passifier

  # Disk storage for a pass
  class Storage

    attr_reader :signature

    # @param [String] scratch directory The directory to use for file storage
    def initialize(options = {})
      @scratch_directory = scratch_directory
    end

    # Directory segments of the path without the root
    # @return [Array<String>] The path broken into string segments
    def directories
      @scratch_directory.split("/")
    end

    # Path to the stored version
    # @param [String] filename The filename to return the path for
    # @return [String] The full path to the file with the passed-in filename
    def path(filename)
      "#{@scratch_directory}/#{filename}"
    end

    # Store the file for the given pass asset to disk
    # @param [Object] asset Store the file for the given pass asset
    def write_file(asset)
      ensure_directory_exists
      File.open(path(asset.filename), 'w') do |file| 
        file.write(asset.content) if asset.respond_to?(:content)
      end
    end

    # Store the files for a group of pass assets
    # @param [Array<Object>] The pass asset objects to store files for
    def store(assets)
      assets = [assets].flatten
      assets.each { |asset| write_file(asset) }
    end
    alias_method :<<, :store

    # Create a zip archive given a filename for the archive and a set of pass assets
    # @param [String] zip_path The desired output path
    # @return [String] The full path of the resulting zip archive
    def zip(zip_path, assets)
      Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE) do |zipfile|
        assets.each { |file| zipfile.add(file.filename, path(file.filename)) }
      end
      archive_path
    end

    # Remove a zip archive
    # @param [String] zip_path The path of the archive to delete
    def remove_zip(zip_path)
      File.delete(zip_path) rescue nil
    end

    protected

    def ensure_directory_exists
      last_directory = ""
      directories.each do |directory|
        Dir.mkdir("/tmp/#{last_directory}#{directory}") rescue nil
        last_directory = "#{directory}/"
      end
    end

  end

end

