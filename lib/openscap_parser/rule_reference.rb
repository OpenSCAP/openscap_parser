# frozen_string_literal: true

# RuleReference interface as an object
module OpenscapParser
  # A class for parsing RuleReference information
  class RuleReference < XmlNode
    def href
      @href ||= @parsed_xml && @parsed_xml['href']
    end

    def label
      @label ||= @parsed_xml&.text
    end

    def to_h
      {
        href:,
        label:
      }
    end
  end
end
