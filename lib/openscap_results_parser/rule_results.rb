# frozen_string_literal: true

require 'openscap_results_parser/rule_result'

module OpenscapParser
  module RuleResults
    def self.included(base)
      base.class_eval do
        def rule_result_nodes
          @rule_result_nodes ||= parsed_xml.xpath('rule-result')
        end

        def rule_results
          rule_result_nodes.map do |node|
            RuleResult.new(parsed_xml: node)
          end
        end
      end
    end
  end
end
