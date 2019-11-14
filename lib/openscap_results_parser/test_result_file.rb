# frozen_string_literal: true

module OpenscapParser
  # A class to represent an XmlFile which contains a <TestResult /> Xccdf type
  class TestResultFile < XmlFile
    include ::OpenscapParser::Benchmarks
    include ::OpenscapParser::TestResults
  end
end
