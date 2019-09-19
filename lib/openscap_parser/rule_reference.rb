# frozen_string_literal: true

# RuleReference interface as an object
module OpenscapParser
  class RuleReference
    def initialize(reference_xml: nil)
      @reference_xml = reference_xml
    end

    def href
      @href ||= @reference_xml && @reference_xml['href']
    end

    def label
      @label ||= @reference_xml && @reference_xml.text
    end
  end
end
