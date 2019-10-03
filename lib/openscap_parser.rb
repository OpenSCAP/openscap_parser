# frozen_string_literal: true
require 'openscap_parser/util'
require 'openscap_parser/benchmarks'
require 'openscap_parser/profiles'
require 'openscap_parser/profile'
require 'openscap_parser/rule'
require 'openscap_parser/rule_result'
require 'openscap_parser/rule_results'
require 'openscap_parser/rules'
require 'openscap_parser/version'
require 'openscap_parser/xml_report'
require 'openscap_parser/datastream'

require 'date'
require 'railtie' if defined?(Rails)

module OpenscapParser
  class Error < StandardError; end

  class Base
    include OpenscapParser::XMLReport
    include OpenscapParser::Profiles
    include OpenscapParser::Rules
    include OpenscapParser::RuleResults
    include OpenscapParser::TestResult

    def initialize(report)
      parsed_xml(report)
    end
  end
end
