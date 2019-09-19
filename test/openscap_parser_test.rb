# frozen_string_literal: true

require 'test_helper'
require 'openscap_parser/rule_reference'

class OpenscapParserTest < Minitest::Test
  def setup
    fake_report = file_fixture('xccdf_report.xml').read
    @profile_ref_id = 'xccdf_org.ssgproject.content_profile_standard'
    @report_parser = ::OpenscapParser::Base.new(fake_report)
  end

  context 'profile' do
    should 'be able to parse it' do
      assert_equal(@profile_ref_id, @report_parser.profiles.first.id)
    end

    should 'not save more than one profile when there are no test results' do
      fake_report = file_fixture('rhel-xccdf-report.xml').read
      @profile_ref_id = 'xccdf_org.ssgproject.content_profile_rht-ccp'
      @report_parser = ::OpenscapParser::Base.new(fake_report)
      assert_equal 1, @report_parser.test_result_profiles.count
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

    should 'parse rule references' do
      rule = @report_parser.rules.find do |r|
        r.id == 'xccdf_org.ssgproject.content_rule_service_atd_disabled'
      end

      references = [
        ["http://iase.disa.mil/stigs/cci/Pages/index.aspx", "CCI-000381"],
        ['http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.'\
         '800-53r4.pdf', "CM-7"]
      ]

      assert_equal references, rule.references.map { |rr| [rr.href, rr.label] }
    end

    should 'parse rule description without newlines' do
      rule = @report_parser.rule_objects.find do |rule_obj|
        rule_obj.id == 'xccdf_org.ssgproject.content_rule_service_atd_disabled'
      end

      desc = <<~DESC.gsub("\n", ' ').strip
        The at and batch commands can be used to
        schedule tasks that are meant to be executed only once. This allows delayed
        execution in a manner similar to cron, except that it is not
        recurring. The daemon atd keeps track of tasks scheduled via
        at and batch, and executes them at the specified time.
        The atd service can be disabled with the following command:
        $ sudo systemctl disable atd.service
      DESC

      assert_equal desc, rule.description
    end
  end
end
