# frozen_string_literal: true

require 'openscap_parser/group'

module OpenscapParser
  # Methods related to finding and saving rule references
  module Groups
    def self.included(base)
      base.class_eval do
        def groups
          @groups ||= group_nodes.map do |group_node|
            OpenscapParser::Group.new(parsed_xml: group_node)
          end
        end

        def group_nodes(xpath = './/Group')
          xpath_nodes(xpath)
        end
      end
    end
  end
end
