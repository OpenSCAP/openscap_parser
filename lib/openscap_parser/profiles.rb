# frozen_string_literal: true

module OpenscapParser
  # Methods related to saving profiles and finding which hosts
  # they belong to
  module Profiles
    def self.included(base)
      base.class_eval do
        def profiles
          @profiles ||= {
            profile_node['id'] => profile_node.at_css('title').text
          }
        end

        private

        def profile_node
          @report_xml.at_xpath(".//xmlns:Profile\
                             [contains('#{test_result_node['id']}', @id)]")
        end

        def test_result_node
          @test_result_node ||= @report_xml.at_css('TestResult')
        end
      end
    end
  end
end
