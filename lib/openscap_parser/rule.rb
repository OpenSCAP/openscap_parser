# frozen_string_literal: true

require 'openscap_parser/rule_identifier'
require 'openscap_parser/rule_references'
require 'openscap_parser/fixes'
require 'openscap_parser/xml_file'

# Mimics openscap-ruby Rule interface
module OpenscapParser
  # A class for parsing Rule information
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
      @title ||= parsed_xml.at_css('title')&.text
    end

    def requires
      @requires ||= parsed_xml.xpath('./requires') &&
                    parsed_xml.xpath('./requires/@idref').flat_map do |r|
                      r.to_s&.split
                    end
    end

    def conflicts
      @conflicts ||= parsed_xml.xpath('./conflicts') &&
                     parsed_xml.xpath('./conflicts/@idref').flat_map do |c|
                       c.to_s&.split
                     end
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

    alias rule_reference_nodes_old rule_reference_nodes
    def rule_reference_nodes(xpath = 'reference')
      rule_reference_nodes_old(xpath)
    end

    def rule_identifier
      @rule_identifier ||= identifier_node && RuleIdentifier.new(parsed_xml: identifier_node)
    end
    alias identifier rule_identifier

    def identifier_node
      @identifier_node ||= parsed_xml.at_xpath('ident')
    end

    def parent_id
      parsed_xml.xpath('../@id').to_s
    end

    def parent_type
      @parent_type = if parsed_xml.xpath("name(..)='Group'")
                       'Group'
                     else
                       'Benchmark'
                     end
    end

    def values
      parsed_xml.xpath('check/check-export').map { |r| r.at_xpath('@value-id')&.text }
    end

    def to_h
      {
        id:, selected:,
        severity:, title:,
        requires:, conflicts:,
        description:, rationale:,
        identifier: rule_identifier.to_h,
        parent_id:,
        parent_type:,
        values:
      }
    end
  end
end
