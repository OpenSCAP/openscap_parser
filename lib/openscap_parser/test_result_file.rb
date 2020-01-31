# frozen_string_literal: true
require 'openscap_parser/xml_file'
require 'openscap_parser/benchmarks'
require 'openscap_parser/test_results'

module OpenscapParser
  # A class to represent an XmlFile which contains a <TestResult /> Xccdf type
  class TestResultFile < XmlFile
    include ::OpenscapParser::Benchmarks
    include ::OpenscapParser::TestResults
  end
end
