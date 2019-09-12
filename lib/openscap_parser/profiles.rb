# frozen_string_literal: true
require 'openscap_parser/test_result'

module OpenscapParser
  # Methods related to saving profiles and finding which hosts
  # they belong to
  module Profiles
    include TestResult

    def self.included(base)
      base.class_eval do
        def profiles
          @profiles ||= {
            profile_node['id'] => profile_node.at_css('title').text
          }
        end

        private

        def profile_node
          @parsed_xml.at_xpath(".//Profile\
                             [contains('#{test_result_node['id']}', @id)]")
        end
      end
    end
  end
end
