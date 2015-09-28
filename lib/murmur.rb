require 'murmur/version'
require 'murmur/ice_interface'
require 'murmur/server'

module Murmur

    def self.client(options={})
        @client = Murmur::Meta.new(options)
    end

    def self.method_missing(method, *args, &block)
        return super unless @client.respond_to?(method)
        @client.send(method, *args, &block)
    end

    def self.respond_to?(method)
        return @client.respond_to?(method) || super
    end

end
