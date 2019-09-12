# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < Minitest::Test
  describe 'profiles are parsed from' do
    include OpenscapParser::Profiles
    include OpenscapParser::XMLReport

    def report_description
      'description'
    end

    def setup
      @profiles = nil
    end

    test 'standard fedora' do
      def test_result_node
        OpenStruct.new(id: ['xccdf_org.ssgproject.content_profile_standard'])
      end

      parsed_xml(file_fixture('xccdf_report.xml').read)

      expected = {
        'xccdf_org.ssgproject.content_profile_standard' => \
        'Standard System Security Profile for Fedora'
      }
      assert_equal expected, profiles
    end

    test 'ospp42 rhel' do
      def test_result_node
        OpenStruct.new(id: ['xccdf_org.open-scap_testresult_xccdf_org.'\
                            'ssgproject.content_profile_ospp42'])
      end

      parsed_xml(file_fixture('rhel-xccdf-report.xml').read)

      expected = {
        'xccdf_org.ssgproject.content_profile_ospp42' => 'OSPP - Protection '\
        'Profile for General Purpose Operating Systems v. 4.2'
      }
      assert_equal expected, profiles
    end
  end
end
