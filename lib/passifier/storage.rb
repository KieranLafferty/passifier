#!/usr/bin/env ruby

module Passifier

  # Disk storage for a pass
  class Storage

    attr_reader :assets, :scratch_directory

    # @param [String] scratch directory The directory to use for file storage
    # @param [Array<Object>] assets The file assets to store
    def initialize(scratch_directory, assets)
      @assets = [assets].flatten
      @scratch_directory = scratch_directory
    end

    # Path to the stored version
    # @param [String] filename The filename to return the path for
    # @return [String] The full path to the file with the passed-in filename
    def path(filename)
      "#{@scratch_directory}/#{filename}"
    end

    # Store the files for a group of pass assets
    # @param [Array<Object>] The pass asset objects to store files for
    def store
      ensure_directory_exists
      @assets.each { |asset| write_file(asset) }
    end
    alias_method :<<, :store

    # Create a zip archive given a filename for the archive and a set of pass assets
    # @param [String] zip_path The desired output path
    # @return [String] The full path of the resulting zip archive
    def zip(zip_path)
      remove_zip(zip_path) # ensure that older version is deleted if it exists
      Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE) do |zipfile|
        @assets.each do |asset| 
          zipfile.add(asset.filename, path(asset.filename))
        end
      end
      zip_path
    end

    # Clean up temp files
    def cleanup
      remove_temp_files
      remove_directory
    end

    # Remove a zip archive
    # @param [String] zip_path The path of the archive to delete
    def remove_zip(zip_path)
      File.delete(zip_path) if File.exists?(zip_path)
    end

    protected

    # Store the file for the given pass asset to disk
    # @param [Object] asset Store the file for the given pass asset
    def write_file(asset)
      File.open(path(asset.filename), 'w') do |file| 
        file.write(asset.content) if asset.respond_to?(:content)
      end
    end

    def remove_directory(directory = nil)
      directory ||= @scratch_directory
      Dir.rmdir(directory) if File.exists?(directory) && File.directory?(directory)
    end

    # Remove assets (created by Passifier::Storage#store)
    def remove_temp_files
      @assets.map do |asset|
        path = path(asset.filename)
        File.delete(path) if File.exists?(path)
      end
    end

    def ensure_directory_exists(directory = nil)
      directory ||= @scratch_directory
      last_directory = ""
      tree = directory.split("/")
      tree.each do |directory|
        dir = "#{last_directory}#{directory}"
        Dir.mkdir(dir) unless File.exists?(dir)
        last_directory = "#{dir}/"
      end
      last_directory
    end

  end

end

