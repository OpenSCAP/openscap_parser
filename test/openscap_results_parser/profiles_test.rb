# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < Minitest::Test
  describe 'profiles are parsed from' do
    test 'test result file standard fedora' do
      test_result_file = OpenscapParser::TestResultFile.new(
        file_fixture('xccdf_report.xml').read
      )

      assert_equal 'xccdf_org.ssgproject.content_profile_standard',
        test_result_file.test_result.profile_id
    end

    test 'test result file ospp42 rhel' do
      test_result_file = OpenscapParser::TestResultFile.new(
        file_fixture('rhel-xccdf-report.xml').read
      )

      assert_equal 'xccdf_org.ssgproject.content_profile_rht-ccp',
        test_result_file.test_result.profile_id
    end
  end
end
