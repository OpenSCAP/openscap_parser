# frozen_string_literal: true
require 'openscap_parser/profiles'
require 'openscap_parser/rule'
require 'openscap_parser/rule_result'
require 'openscap_parser/rules'
require 'openscap_parser/version'
require 'openscap_parser/xml_report'
require 'openscap_parser/ds'

require 'date'

module OpenscapParser
  class Error < StandardError; end

  class Base
    include OpenscapParser::XMLReport
    include OpenscapParser::Profiles
    include OpenscapParser::Rules

    def initialize(report)
      report_xml(report)
    end

    def score
      test_result_node.search('score').text.to_f
    end

    def start_time
      @start_time ||= DateTime.parse(test_result_node['start-time'])
    end

    def end_time
      @end_time ||= DateTime.parse(test_result_node['end-time'])
    end

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
