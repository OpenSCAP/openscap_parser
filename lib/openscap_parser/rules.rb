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
          @rule_objects ||= rule_nodes.map do |rule_node|
            Rule.new(rule_xml: rule_node)
          end
        end
        alias :rules :rule_objects

        def rule_nodes(xpath = ".//Rule")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
