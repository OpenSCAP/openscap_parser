# frozen_string_literal: true

require 'openscap_parser/xml_file'
require 'openscap_parser/rule_reference'

module OpenscapParser
  # Methods related to finding and saving rule references
  module RuleReferences
    def self.included(base)
      base.class_eval do
        def rule_reference_strings
          @rule_reference_strings ||= rule_references.map do |rr|
            "#{rr.label}#{rr.href}"
          end
        end

        def rule_references
          @rule_references ||= rule_reference_nodes.map do |node|
            OpenscapParser::RuleReference.new(parsed_xml: node)
          end.uniq do |reference|
            [reference.label, reference.href]
          end
        end
        alias :references :rule_references

        def rule_reference_nodes(xpath = ".//Rule/reference")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
