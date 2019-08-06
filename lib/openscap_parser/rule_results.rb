# frozen_string_literal: true
require 'openscap_parser/test_result'

module OpenscapParser
  module RuleResults
    include TestResult

    def self.included(base)
      base.class_eval do
        def rule_results
          @rule_results ||= test_result_node.search('rule-result').map do |rr|
            rule_result_oscap = RuleResult.new
            rule_result_oscap.id = rr.attributes['idref'].value
            rule_result_oscap.result = rr.search('result').first.text
            rule_result_oscap
          end
        end
      end
    end
  end
end
