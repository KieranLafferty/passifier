#!/usr/bin/env ruby

module Passifier

  # Content derived from a url
  # Used to pull in the background images
  class UrlSource

    attr_reader :content, :name, :url
    alias_method :filename, :name

    def initialize(name, url)
      @name = name
      @url = url
      populate_content
    end

    private

    def populate_content
      uri = URI(@url)
      res = Net::HTTP.get_response(uri)
      @content = res.body   
    end

  end

end
