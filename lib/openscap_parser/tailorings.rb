# frozen_string_literal: true

require 'openscap_parser/tailoring'

module OpenscapParser
  # Methods related to parsing Xccdf Tailoring types
  module Tailorings
    def self.included(base)
      base.class_eval do
        def tailoring
          @tailoring ||= OpenscapParser::Tailoring.new(
            parsed_xml: tailoring_node
          )
        end

        def tailoring_node(xpath = ".//Tailoring")
          xpath_node(xpath)
        end
      end
    end
  end
end
