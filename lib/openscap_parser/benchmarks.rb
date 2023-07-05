# frozen_string_literal: true

require 'openscap_parser/benchmark'

module OpenscapParser
  # Methods related to saving profiles and finding which hosts
  # they belong to
  module Benchmarks
    def self.included(base)
      base.class_eval do
        def benchmark
          @benchmark ||= OpenscapParser::Benchmark.new(parsed_xml: benchmark_node)
        end

        def benchmark_node(xpath = './/Benchmark')
          xpath_node(xpath)
        end
      end
    end
  end
end
