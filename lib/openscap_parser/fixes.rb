# frozen_string_literal: true

require 'openscap_parser/fix'

module OpenscapParser
  module Fixes
    def self.included(base)
      base.class_eval do
        def fixes
          @fixes ||= fix_nodes.map do |fix_node|
            OpenscapParser::Fix.new(parsed_xml: fix_node)
          end
        end

        def fix_nodes(xpath = ".//fix")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
