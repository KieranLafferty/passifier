#!/usr/bin/env ruby

module Passifier

  class StaticFile

    attr_reader :content, :name, :path
    alias_method :filename, :name

    def initialize(name, path_to_file)
      @name = name
      @path = path_to_file
      @content = File.open(@path, 'rb') {|file| file.read }
    end

  end

end



