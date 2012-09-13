#!/usr/bin/env ruby

module Passifier

  # A single local static file asset
  class StaticFile

    attr_reader :content, :name, :path
    alias_method :filename, :name

    # @param [String, Symbol] name The name of the asset
    # @param [String] path_to_file The local path to the asset file
    def initialize(name, path_to_file)
      @name = name
      @path = path_to_file
      @content = File.open(@path, 'rb') {|file| file.read }
    end

  end

end



