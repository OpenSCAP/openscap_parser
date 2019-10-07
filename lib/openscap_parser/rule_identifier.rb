# frozen_string_literal: true

# RuleIdentifier interface as an object
module OpenscapParser
  class RuleIdentifier < XmlNode
    def label
      @label ||= @parsed_xml && @parsed_xml.text
    end

    def system
      @system ||= @parsed_xml && @parsed_xml['system']
    end
  end
end
