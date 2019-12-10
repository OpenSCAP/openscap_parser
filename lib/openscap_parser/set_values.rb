# frozen_string_literal: true

require 'openscap_parser/set_value'

module OpenscapParser
  module SetValues
    def self.included(base)
      base.class_eval do
        def set_values
          @set_values ||= set_value_nodes.map do |set_value_node|
            OpenscapParser::SetValue.new(parsed_xml: set_value_node)
          end
        end

        def set_value_nodes(xpath = ".//set-value")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
