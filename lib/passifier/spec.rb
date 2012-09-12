#!/usr/bin/env ruby

module Passifier

  # Pass specification, representing the pass.json file
  class Spec

    attr_reader :hash, :serial_number
    alias_method :to_hash, :hash

    # @param [String] serial_number An ID for this Spec, used in the pass.json file as the Serial Number
    # @param [Hash] hash The pass.json contents as a hash
    def initialize(serial_number, hash)
      @serial_number = serial_number
      @hash = hash
    end

    # The contents of the pass.json file
    # @return [String] The pass.json contents as a String
    def to_json
      to_hash.to_json
    end
    alias_method :content, :to_json

    def filename
      "pass.json"
    end

  end

end
