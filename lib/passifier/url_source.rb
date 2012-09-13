#!/usr/bin/env ruby

module Passifier

  # Asset derived from a url
  # Used to pull in the background images
  class UrlSource

    attr_reader :content, :name, :url
    alias_method :filename, :name

    # @param [String, Symbol] name The name of the asset
    # @param [String] url The url to request the asset content from
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
