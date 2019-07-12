# frozen_string_literal: true

# Mimics openscap-ruby Rule interface
module OpenscapParser
  class Rule
    def initialize(rule_xml: nil, test_result_node: nil)
      @rule_xml = rule_xml
      @test_result_node = test_result_node
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
      @rationale ||= newline_to_whitespace(rationale_node.children.text) if rationale_node && rationale_node.children && rationale_node.children.text
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

    def fixes
      @rule_xml.xpath('./fix').map { |fix_xml| parse_fix(fix_xml) }
    end

    def to_h
      {
        :id => id,
        :severity => severity,
        :title => title,
        :description => description,
        :rationale => rationale,
        :references => references,
        :identifier => identifier,
        :fixes => fixes
      }
    end

    private

    def newline_to_whitespace(string)
      string.gsub(/ *\n+/, " ").strip
    end

    def parse_fix(fix_xml)
      return {} unless fix_xml
      fix_hash = { :id => fix_xml['id'], :value => fix_xml.text, :system => fix_xml['system'] }
      if sub_xml = fix_xml.at_xpath('sub')
        idref = sub_xml['idref']
        sub = { :idref => idref }
        result_sub = @test_result_node.at_xpath("set-value[contains('#{idref}', @idref)]")
        sub[:value] = result_sub.text if result_sub
        fix_hash[:sub] = sub
      end
      fix_hash
    end
  end
end

