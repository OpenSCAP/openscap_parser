# frozen_string_literal: true

# RuleReference interface as an object
module OpenscapParser
  class RuleReference < XmlNode
    def href
      @href ||= @parsed_xml && @parsed_xml['href']
    end

    def label
      @label ||= @parsed_xml && @parsed_xml.text
    end

    def to_h
      {
        href: href,
        label: label
      }
    end
  end
end
