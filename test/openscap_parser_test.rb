# frozen_string_literal: true

require 'test_helper'

class OpenscapParserTest < Minitest::Test
  def setup
    fake_report = file_fixture('xccdf_report.xml').read
    @profile = {
      'xccdf_org.ssgproject.content_profile_standard' =>
      'Standard System Security Profile for Fedora'
    }
    @report_parser = ::OpenscapParser::Base.new(fake_report)
  end

  context 'profile' do
    should 'be able to parse it' do
      assert_equal(@profile, @report_parser.profiles)
    end

    should 'not save more than one profile when there are no test results' do
      fake_report = file_fixture('rhel-xccdf-report.xml').read
      @profile = {
        'xccdf_org.ssgproject.content_profile_rht-ccp' =>
        'Red Hat Corporate Profile for Certified Cloud Providers (RH CCP)'
      }
      @report_parser = ::OpenscapParser::Base.new(fake_report)
      assert_equal 1, @report_parser.profiles.count
    end
  end

  context 'host' do
    should 'be able to parse host name' do
      assert_equal 'lenovolobato.lobatolan.home', @report_parser.host
    end
  end

  test 'score can be parsed' do
    assert_equal(16.220238, @report_parser.score)
  end

  context 'rules' do
    setup do
      @arbitrary_rules = [
        # rubocop:disable Metrics/LineLength
        'xccdf_org.ssgproject.content_rule_dir_perms_world_writable_system_owned',
        'xccdf_org.ssgproject.content_rule_bios_enable_execution_restrictions',
        'xccdf_org.ssgproject.content_rule_gconf_gnome_screensaver_lock_enabled',
        'xccdf_org.ssgproject.content_rule_selinux_all_devicefiles_labeled'
        # rubocop:enable Metrics/LineLength
      ]
    end

    should 'list all rules' do
      assert_empty(@arbitrary_rules - @report_parser.rule_ids)
    end
  end
end
