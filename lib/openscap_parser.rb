# frozen_string_literal: true
require 'openscap_parser/profiles'
require 'openscap_parser/rule'
require 'openscap_parser/rule_result'
require 'openscap_parser/rule_results'
require 'openscap_parser/rules'
require 'openscap_parser/version'
require 'openscap_parser/xml_report'
require 'openscap_parser/ds'
require 'openscap_parser/arf'

require 'date'

module OpenscapParser
  class Error < StandardError; end

  class Base
    include OpenscapParser::XMLReport
    include OpenscapParser::Profiles
    include OpenscapParser::Rules
    include OpenscapParser::RuleResults

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
  end
end
