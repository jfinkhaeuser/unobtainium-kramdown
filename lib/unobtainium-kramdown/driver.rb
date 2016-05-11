# coding: utf-8
#
# unobtainium-kramdown
# https://github.com/jfinkhaeuser/unobtainium-kramdown
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-kramdown contributors.
# All rights reserved.
#

require 'unobtainium'

module Unobtainium
  ##
  # Kramdown namespace
  module Kramdown

    ##
    # Driver implementation using kramdown (and open-uri).
    class Driver
      class << self
        ##
        # Return true if the given label matches this driver implementation,
        # false otherwise.
        def matches?(label)
          return :kramdown == label.to_sym
        end

        ##
        # Ensure that the driver's preconditions are fulfilled.
        def ensure_preconditions(_, _)
          require 'kramdown'
          require 'open-uri'
        rescue LoadError => err
          raise LoadError, "#{err.message}: you need to add "\
                "'kramdown' to your Gemfile to use this driver!",
                err.backtrace
        end

        ##
        # Create and return a driver instance
        def create(_, _)
          driver = ::Unobtainium::Kramdown::Driver.new
          return driver
        end
      end # class << self

      ##
      # "Go to" the given URI, i.e. open it and retain contents.
      def goto(uri)
        reset

        # Fetch content
        open(uri) do |f|
          @meta[:uri] = uri.dup
          if f.respond_to?(:meta)
            @meta[:headers] = f.meta.dup
            @meta[:status] = f.status.dup
            @meta[:base_uri] = f.base_uri.dup
          end

          if f.respond_to?(:metas)
            @meta[:split_headers] = f.metas.dup
          end

          @content = f.read
        end

        # Pass content to Kramdown
        @parsed = ::Kramdown::Document.new(@content, @options)
      end

      ##
      # @return (String) The raw page content, or nil
      attr_reader :content

      ##
      # @return (Hash) Any page metadata, or an empty Hash
      attr_reader :meta

      ##
      # @return (::Kramdown::Options) parser options for all subsequent
      #   requests.
      attr_accessor :options

      ##
      # Map any missing method to kramdown
      def respond_to_missing?(meth, include_private = false)
        if not @parsed.nil?
          # Kramdown::Document does not implement respond_to*?, so we can't
          # be entirely certain this works...
          if @parsed.respond_to?(meth, include_private)
            return true
          end
          # ... therefore assume to_* to be handled by Kramdown::Document
          if meth.to_s =~ /^to_.+/
            return true
          end
        end
        return super
      end

      ##
      # Map any missing method to kramdown
      def method_missing(meth, *args, &block)
        if not @parsed.nil?
          if @parsed.respond_to?(meth) or meth.to_s =~ /^to_.+/
            return @parsed.send(meth.to_s, *args, &block)
          end
        end
        return super
      end

      private

      ##
      # Private initialize to force use of Driver#create.
      def initialize
        reset

        @options = ::Kramdown::Options.defaults
      end

      ##
      # Clear all data
      def reset
        @content = nil
        @meta = {}
        @parsed = nil
      end
    end # class Driver

  end # module Kramdown
end # module Unobtainium

::Unobtainium::Driver.register_implementation(
    ::Unobtainium::Kramdown::Driver,
    __FILE__
)
