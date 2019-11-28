# frozen_string_literal: true

require 'test_helper'

class TestResultFileTest < Minitest::Test
  def setup
    @test_result_file = OpenscapParser::TestResultFile.new(
      file_fixture('xccdf_report.xml').read
    )

    @arf_result_file = OpenscapParser::TestResultFile.new(
      file_fixture('arf_report_cs2.xml').read
    )
  end

  context 'benchmark' do
    test 'report_description' do
      assert_match(/^This guide presents/,
                   @test_result_file.benchmark.description)
    end

    test 'be able to parse it' do
      assert_equal 'xccdf_org.ssgproject.content_profile_standard',
        @test_result_file.benchmark.profiles.first.id
    end

    context 'profiles' do
    end

    context 'rules' do
      test 'list all rules' do
        arbitrary_rules = [
          # rubocop:disable Metrics/LineLength
          'xccdf_org.ssgproject.content_rule_dir_perms_world_writable_system_owned',
          'xccdf_org.ssgproject.content_rule_bios_enable_execution_restrictions',
          'xccdf_org.ssgproject.content_rule_gconf_gnome_screensaver_lock_enabled',
          'xccdf_org.ssgproject.content_rule_selinux_all_devicefiles_labeled'
          # rubocop:enable Metrics/LineLength
        ]

        assert_empty(
          arbitrary_rules - @test_result_file.benchmark.rules.map(&:id)
        )
      end

      test 'removes newlines from rule description' do
        rule = @test_result_file.benchmark.rules.find do |rule|
          rule.id == 'xccdf_org.ssgproject.content_rule_service_atd_disabled'
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

    context 'rule_references' do
      test 'rule references' do
        rule = @test_result_file.benchmark.rules.find do |r|
          r.id == 'xccdf_org.ssgproject.content_rule_service_atd_disabled'
        end

        references = [
          ["http://iase.disa.mil/stigs/cci/Pages/index.aspx", "CCI-000381"],
          ['http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.'\
           '800-53r4.pdf', "CM-7"]
        ]

        assert_equal references, rule.references.map { |rr| [rr.href, rr.label] }
      end
    end
  end

  context 'test result' do
    test 'report_host' do
      assert_match @test_result_file.test_result.host,
        'lenovolobato.lobatolan.home'
    end

    test 'score can be parsed' do
      assert_equal(16.220238, @test_result_file.test_result.score)
    end

    context 'profiles' do
      test 'test_result profile_id' do
        assert_equal 'xccdf_org.ssgproject.content_profile_standard',
          @test_result_file.test_result.profile_id
      end
    end

    context 'rules' do
      test 'should parse rules for xccdf report' do
        parse_rules @test_result_file
      end

      test 'should parse rules for arf report' do
        parse_rules @arf_result_file
      end
    end

    context 'set values' do
      test 'should parse set values for xccdf report' do
        parse_set_values @test_result_file
      end

      test 'should parse set values for arf report' do
        parse_set_values @arf_result_file
      end
    end
  end

  def parse_set_values(result_file)
    set_values = result_file.test_result.set_values.map(&:to_h)
    idrefs = set_values.map { |val| val[:idref] }
    texts = set_values.map { | val| val[:text] }
    refute_empty set_values
    assert_equal idrefs, idrefs.compact
    assert_equal texts, texts.compact
  end

  def parse_rules(result_file)
    rules = result_file.benchmark.rules.map(&:to_h)
    ids = rules.map { |rule| rule[:id] }
    titles = rules.map { |rule| rule[:title] }
    selected = rules.map { |rule| rule[:selected] }
    refute_empty rules
    assert_equal ids, ids.compact
    assert_equal titles, titles.compact
    assert_equal selected, selected.compact
  end
end
