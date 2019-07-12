# frozen_string_literal: true

module OpenscapParser
  # Methods related to parsing rules
  module Rules
    def self.included(base)
      base.class_eval do
        def rule_ids
          test_result_node.xpath('.//rule-result/@idref').map(&:value)
        end

        def rule_objects
          return @rule_objects unless @rule_objects.nil?

          @rule_objects ||= @report_xml.search('Rule').map do |rule|
            Rule.new(rule_xml: rule, test_result_node: test_result_node)
          end
        end
      end
    end
  end
end
