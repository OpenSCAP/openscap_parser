# frozen_string_literal: true

require 'openscap_parser/regex_handler'

module OpenscapParser
  # A class for parsing Profile information
  class Profile < XmlNode
    def id
      @id ||= @parsed_xml['id']
    end

    def extends_profile_id
      @extends_profile_id ||= @parsed_xml['extends']
    end

    def title
      @title ||=          @parsed_xml.at_css('title')&.text
    end
    alias name title

    def description
      @description ||= @parsed_xml.at_css('description')&.text
    end

    def selected_rule_ids
      # Look for selected rule ids where the idref contains '_rule_' that is not preceded by 'group'
      @selected_rule_ids ||= @parsed_xml.xpath("select[@selected='true']
                                                      [regex(@idref, '^((?!_group_).)*?(_rule_).*$')]
                                                      /@idref", RegexHandler)&.map(&:text)
    end

    def unselected_group_ids
      # Look for group ids that are not selected where the idref contains '_group_' that is not preceded by 'rule'
      @unselected_group_ids ||= @parsed_xml.xpath("select[@selected='false']
                                                         [regex(@idref, '^((?!_rule_).)*?(_group_).*$')]
                                                         /@idref", RegexHandler)&.map(&:text)
    end

    def selected_entity_ids
      @selected_entity_ids ||= @parsed_xml.xpath("select[@selected='true']/@idref")&.map(&:text)
    end

    def refined_values
      @refined_values ||= @parsed_xml.xpath('refine-value').each_with_object({}) do |element, rv|
        rv[element.at_xpath('@idref').text] = element.at_xpath('@selector').text
      end
    end

    def refined_rules(attribute)
      @refined_rules ||= @parsed_xml.xpath("refine-rule[@#{attribute}]").each_with_object({}) do |element, rr|
        rr[element.at_xpath('@idref').text] = element.at_xpath("@#{attribute}")&.text
      end
    end

    def refined_rule_severity
      refined_rules('severity')
    end

    def refined_rule_role
      refined_rules('role')
    end

    def refined_rule_weight
      refined_rules('weight')
    end

    def to_h
      {
        id:,
        title:,
        description:,
        refined_values:,
        refined_rule_severity:,
        refined_rule_role:,
        refined_rule_weight:
      }
    end
  end
end
