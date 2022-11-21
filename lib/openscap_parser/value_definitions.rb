# frozen_string_literal: true

require 'openscap_parser/value_definition'

module OpenscapParser
  # Methods related to parsing values
  module ValueDefinitions
    def self.included(base)
      base.class_eval do
        def value_definitions
          @value_definitions ||= value_definition_nodes.map do |vdn|
            ValueDefinition.new(parsed_xml: vdn)
          end
        end

        def value_definition_nodes(xpath = ".//Value")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
