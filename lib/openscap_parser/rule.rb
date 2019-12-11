# frozen_string_literal: true

require 'openscap_parser/rule_identifier'
require 'openscap_parser/rule_references'
require 'openscap_parser/fixes'
require 'openscap_parser/xml_file'

# Mimics openscap-ruby Rule interface
module OpenscapParser
  class Rule < XmlNode
    include OpenscapParser::Util
    include OpenscapParser::RuleReferences
    include OpenscapParser::Fixes

    def id
      @id ||= parsed_xml['id']
    end

    def selected
      @selected ||= parsed_xml['selected']
    end

    def severity
      @severity ||= parsed_xml['severity']
    end

    def title
      @title ||= parsed_xml.at_css('title') &&
        parsed_xml.at_css('title').text
    end

    def description
      @description ||= newline_to_whitespace(
        parsed_xml.at_css('description') &&
          parsed_xml.at_css('description').text || ''
      )
    end

    def rationale
      @rationale ||= newline_to_whitespace(
        parsed_xml.at_css('rationale') &&
          parsed_xml.at_css('rationale').text || ''
      )
    end

    alias :rule_reference_nodes_old :rule_reference_nodes
    def rule_reference_nodes(xpath = "reference")
      rule_reference_nodes_old(xpath)
    end

    def rule_identifier
      @identifier ||= RuleIdentifier.new(parsed_xml: identifier_node)
    end
    alias :identifier :rule_identifier

    def identifier_node
      @identifier_node ||= parsed_xml.at_xpath('ident')
    end

    def to_h
      {
        :id => id,
        :selected => selected,
        :severity => severity,
        :title => title,
        :description => description,
        :rationale => rationale,
        :identifier => rule_identifier.to_h
      }
    end
  end
end
