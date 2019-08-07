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
      rule_node ||= @rule_xml.at_css('description')
      @description ||= newline_to_whitespace(rule_node.text) if rule_node && rule_node.text
    end

    def rationale
      rationale_node ||= @rule_xml.at_css('rationale')
      @rationale ||= newline_to_whitespace(rationale_node.children.text) if rationale_node &&
        rationale_node.children &&
        rationale_node.children.text
    end

    def references
      @references ||= @rule_xml.css('reference').map do |node|
        { href: node['href'], label: node.text }
      end
    end

    def identifier
      @identifier ||= {
        label: @rule_xml.at_css('ident') && @rule_xml.at_css('ident').text,
        system: (ident = @rule_xml.at_css('ident')) && ident['system']
      }
    end

    private

    def newline_to_whitespace(string)
      string.gsub(/ *\n+/, " ").strip
    end
  end
end
