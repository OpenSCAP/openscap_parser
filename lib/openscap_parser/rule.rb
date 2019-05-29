# frozen_string_literal: true

# Mimics openscap-ruby Rule interface
module OpenscapParser
  class Rule
    def initialize(rule_xml: nil)
      @rule_xml = rule_xml
    end

    def id
      @id ||= @rule_xml['id']
    end

    def severity
      @severity ||= @rule_xml['severity']
    end

    def title
      @title ||= @rule_xml.at_css('title').children.first.text
    end

    def description
      @description ||= @rule_xml.at_css('description').text.delete("\n")
    end

    def rationale
      @rationale ||= @rule_xml.at_css('rationale').children.text.delete("\n")
    end
  end
end

