# frozen_string_literal: true

require 'openscap_parser/sub'

module OpenscapParser
  module Subs
    def self.included(base)
      base.class_eval do
        def subs
          return [] unless sub_nodes
          @subs ||= sub_nodes.map do |xml|
            Sub.new(parsed_xml: xml)
          end
        end

        def sub_nodes(xpath = './/sub')
          @sub_nodes ||= xpath_nodes(xpath)
        end
      end
    end
  end
end
