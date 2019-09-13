# frozen_string_literal: true

module OpenscapParser
  module TestResult
    def self.included(base)
      base.class_eval do
        def score
          @score ||= test_result_node &&
            test_result_node.search('score').text.to_f
        end

        def start_time
          @start_time ||= test_result_node &&
            DateTime.parse(test_result_node['start-time'])
        end

        def end_time
          @end_time ||= test_result_node &&
            DateTime.parse(test_result_node['end-time'])
        end

        def test_result_profiles
          @test_result_profiles ||= test_result_profile_nodes.inject({}) do |profiles, profile_node|
            profiles[profile_node['id']] = profile_node.at_css('title').text

            profiles
          end
        end

        def test_result_node
          @test_result_node ||= xpath_node('.//TestResult')
        end

        def test_result_profile_id
          test_result_node.xpath('./profile/@idref').text
        end

        private

        def test_result_profile_nodes
          profile_nodes(".//Profile [@id='#{test_result_profile_id}']")
        end
      end
    end
  end
end
