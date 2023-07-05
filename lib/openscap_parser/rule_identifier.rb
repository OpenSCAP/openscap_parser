# frozen_string_literal: true

# RuleIdentifier interface as an object
module OpenscapParser
  # A class for parsing RuleIdentifier information
  class RuleIdentifier < XmlNode
    def label
      @label ||= @parsed_xml&.text
    end

    def system
      @system ||= @parsed_xml && @parsed_xml['system']
    end

    def to_h
      {
        label:,
        system:
      }
    end
  end
end
