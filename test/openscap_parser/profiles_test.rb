# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < Minitest::Test
  def test_result
    OpenStruct.new(id: ['xccdf_org.ssgproject.content_profile_standard'])
  end

  def report_description
    'description'
  end

  include OpenscapParser::Profiles
  include OpenscapParser::XMLReport

  def setup
    report_xml(file_fixture('xccdf_report.xml').read)
  end

  test 'profiles' do
    expected = {
      'xccdf_org.ssgproject.content_profile_standard' => \
      'Standard System Security Profile for Fedora'
    }
    assert_equal expected, profiles
  end
end
