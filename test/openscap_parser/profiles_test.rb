# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < Minitest::Test
  describe 'profiles are parsed from' do
    class TestParser
      include OpenscapParser::Profiles
      include OpenscapParser::XMLReport
      include OpenscapParser::TestResult

      def report_description
        'description'
      end
    end

    def setup
      @profiles = nil
    end

    test 'standard fedora' do
      class TestParser
        def test_result_profile_id
          'xccdf_org.ssgproject.content_profile_standard'
        end
      end

      test_parser = TestParser.new

      test_parser.parsed_xml(file_fixture('xccdf_report.xml').read)

      expected = {
        'xccdf_org.ssgproject.content_profile_standard' => \
        'Standard System Security Profile for Fedora'
      }
      assert_equal expected, test_parser.test_result_profiles
    end

    test 'ospp42 rhel' do
      class TestParser
        def test_result_profile_id
          'xccdf_org.ssgproject.content_profile_ospp42'
        end
      end

      test_parser = TestParser.new

      test_parser.parsed_xml(file_fixture('rhel-xccdf-report.xml').read)

      expected = {
        'xccdf_org.ssgproject.content_profile_ospp42' => 'OSPP - Protection '\
        'Profile for General Purpose Operating Systems v. 4.2'
      }
      assert_equal expected, test_parser.test_result_profiles
    end
  end
end
