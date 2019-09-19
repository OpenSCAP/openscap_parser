# frozen_string_literal: true

require 'openscap_parser/rule_identifier'
require 'openscap_parser/rule_reference'

# Mimics openscap-ruby Rule interface
module OpenscapParser
  class Rule
    def initialize(rule_xml: nil)
      @rule_xml = rule_xml
    end

    def id
      @id ||= @rule_xml['id']
    end

    def selected
      @selected ||= @rule_xml['selected']
    end

    def severity
      @severity ||= @rule_xml['severity']
    end

    def title
      @title ||= @rule_xml.at_css('title') &&
        @rule_xml.at_css('title').text
    end

    def description
      @description ||= newline_to_whitespace(
        @rule_xml.at_css('description') &&
          @rule_xml.at_css('description').text || ''
      )
    end

    def rationale
      @rationale ||= newline_to_whitespace(
        @rule_xml.at_css('rationale') &&
          @rule_xml.at_css('rationale').text || ''
      )
    end

    def references
      @references ||= reference_nodes.map do |node|
        RuleReference.new(reference_xml: node)
      end
    end

    def reference_nodes
      @reference_nodes ||= @rule_xml.xpath('reference')
    end

    def identifier
      @identifier ||= RuleIdentifier.new(identifier_xml: @identifier_node)
    end

    def identifier_node
      @identifier_node ||= @rule_xml.at_xpath('ident')
    end

    private

    def newline_to_whitespace(string)
      string.gsub(/ *\n+/, " ").strip
    end
  end
end
