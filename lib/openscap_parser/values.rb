# frozen_string_literal: true

require 'openscap_parser/value'

module OpenscapParser
  # Methods related to parsing values
  module Values
    def self.included(base)
      base.class_eval do
        def values
          @values ||= value_nodes.map do |vdn|
            Value.new(parsed_xml: vdn)
          end
        end

        def value_nodes(xpath = ".//Value")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
