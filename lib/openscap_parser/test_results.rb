# frozen_string_literal: true

require 'openscap_parser/test_result'

module OpenscapParser
  # Methods related to finding and saving TestResults
  module TestResults
    def self.included(base)
      base.class_eval do
        def test_result
          TestResult.new(parsed_xml: test_result_node)
        end

        def test_result_node
          @test_result_node ||= xpath_node('.//TestResult')
        end
      end
    end
  end
end
