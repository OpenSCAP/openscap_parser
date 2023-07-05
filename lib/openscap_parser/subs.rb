# frozen_string_literal: true

require 'openscap_parser/sub'

module OpenscapParser
  # Methods related to finding and saving Subs
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

        def map_sub_nodes(children, set_values)
          children.map do |child|
            next child if child.name == 'text'
            next replace_sub(Sub.new(parsed_xml: child), set_values) if child.name == 'sub'

            child
          end
        end

        private

        def replace_sub(sub, set_values)
          set_value = set_values.find { |sv| sv.id == sub.id }
          return unless set_value

          set_value.parsed_xml.children.first
        end
      end
    end
  end
end
