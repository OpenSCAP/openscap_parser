# frozen_string_literal: true

# RuleIdentifier interface as an object
module OpenscapParser
  class RuleIdentifier
    def initialize(identifier_xml: nil)
      @identifier_xml = identifier_xml
    end

    def label
      @label ||= @identifier_xml && @identifier_xml.text
    end

    def system
      @system ||= @identifier_xml && @identifier_xml['system']
    end
  end
end
