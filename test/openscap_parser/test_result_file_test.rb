# frozen_string_literal: true

require 'test_helper'

class TestResultFileTest < Minitest::Test
  def setup
    @test_result_file = OpenscapParser::TestResultFile.new(
      file_fixture('xccdf_report.xml').read
    )

    @test_result_file2 = OpenscapParser::TestResultFile.new(
      file_fixture('xccdf_report_with_conflicts_and_requires.xml').read
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
      test 'profile_id' do
        assert_match(/^xccdf_org.ssgproject.content_profile_C2S/,
                     @test_result_file2.benchmark.profiles.first.id)
      end

      test 'profile_selected_rule_ids' do
        assert_equal(238, @test_result_file2.benchmark.profiles.first.selected_rule_ids.length)
        refute_includes(@test_result_file2.benchmark.profiles.first.selected_rule_ids, "xccdf_org.ssgproject.rules_group_crypto")
        refute_includes(@test_result_file2.benchmark.profiles.first.selected_rule_ids, "xccdf_org.ssgproject.content_group_rule_crypto")
        refute_includes(@test_result_file2.benchmark.profiles.first.selected_rule_ids, "xccdf_org.ssgproject.contentrule_group_crypto")
        refute_includes(@test_result_file2.benchmark.profiles.first.selected_rule_ids, "xccdf_org.ssgproject.content_group_rule_group_crypto")
      end

      test 'profile_unselected_group_ids' do
        assert_equal(186, @test_result_file.benchmark.profiles.first.unselected_group_ids.count)
        assert_includes(@test_result_file.benchmark.profiles.first.unselected_group_ids, "xccdf_org.ssgproject.content_group_mcafee_security_software")
        assert_includes(@test_result_file.benchmark.profiles.first.unselected_group_ids, "xccdf_org.ssgproject.content_group_mcafee_hbss_software")
        assert_includes(@test_result_file.benchmark.profiles.first.unselected_group_ids, "xccdf_org.ssgproject.content_group_certified-vendor")
        assert_includes(@test_result_file.benchmark.profiles.first.unselected_group_ids, "xccdf_org.ssgproject.content_group_restrictions")
      end

      test 'profile_selected_entity_ids' do
        assert_equal(248, @test_result_file2.benchmark.profiles.first.selected_entity_ids.length)
      end
    end

    context 'groups' do
      test 'group_id' do
        assert_match(/^xccdf_org.ssgproject.content_group_system/,
                     @test_result_file2.benchmark.groups.first.id)
      end

      test 'group_no_conflicts' do
        assert_equal([], @test_result_file2.benchmark.groups.first.conflicts)
      end

      test 'group_with_conflicts' do
        assert_equal(["xccdf_org.ssgproject.content_rule_selinux_state",
                      "xccdf_org.ssgproject.content_group_mcafee_security_software"],
                     @test_result_file2.benchmark.groups[1].conflicts)
      end

      test 'group_no_requires' do
        assert_equal([], @test_result_file2.benchmark.groups[1].requires)
      end

      test 'group_with_requires' do
        assert_equal(['A', 'B', 'C'], @test_result_file2.benchmark.groups.first.requires)
      end

      test 'group_description' do
        assert_match(/^Contains rules that check correct system settings./,
                     @test_result_file2.benchmark.groups.first.description)
      end

      test 'group_parent_id_benchmark' do
        assert_match(/^xccdf_org.ssgproject.content_benchmark_RHEL-7/,
                     @test_result_file2.benchmark.groups.first.parent_id)
      end

      test 'group_parent_id_group' do
        assert_match(/^xccdf_org.ssgproject.content_group_system/,
                     @test_result_file2.benchmark.groups[1].parent_id)
      end

      test 'group_parent_type_with_benchmark_parent' do
        assert_match(/^Benchmark/,
                     @test_result_file2.benchmark.groups.first.parent_type)
      end

      test 'group_parent_type_with_group_parent' do
        assert_match(/^Group/,
                     @test_result_file2.benchmark.groups[1].parent_type)
      end
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

      test 'rule_id' do
        assert_match(/^xccdf_org.ssgproject.content_rule_prefer_64bit_os2/,
                     @test_result_file2.benchmark.rules.first.id)
      end
      test 'rule_no_conflicts' do
        assert_equal([], @test_result_file2.benchmark.rules[1].conflicts)
      end
      test 'rule_with_conflicts' do
        assert_equal(["xccdf_org.ssgproject.content_group_system",
                      "xccdf_org.ssgproject.content_rule_selinux_state"],
                     @test_result_file2.benchmark.rules.first.conflicts)
      end
      test 'rule_no_requires' do
        assert_equal([], @test_result_file2.benchmark.rules.first.requires)
      end
      test 'rule_with_requires' do
        assert_equal(["xccdf_org.ssgproject.content_rule_package_audit_installed",
                      "xccdf_org.ssgproject.content_group_integrity",
                      "xccdf_org.ssgproject.content_group_software-integrity"], 
                     @test_result_file2.benchmark.rules[1].requires)
      end
      test 'rule_description' do
        assert_match(/^Prefer installation of 64-bit operating systems when the CPU supports it./,
                     @test_result_file2.benchmark.rules[1].description)
      end
      test 'rule_parent_id_benchmark' do
        assert_match(/^xccdf_org.ssgproject.content_benchmark_RHEL-7/,
                     @test_result_file2.benchmark.rules.first.parent_id)
      end
      test 'rule_parent_id_group' do
        assert_match(/^xccdf_org.ssgproject.content_group_software/,
                     @test_result_file2.benchmark.rules[1].parent_id)
      end
      test 'rule_parent_type_with_benchmark_parent' do
        assert_match(/^Benchmark/,
                     @test_result_file2.benchmark.rules.first.parent_type)
      end
      test 'rule_parent_type_with_group_parent' do
        assert_match(/^Group/,
                     @test_result_file2.benchmark.rules[1].parent_type)
      end
    end

    context 'value_definitions' do
      test 'value_description' do
        assert_match(/^Specify the email address for designated personnel if baseline configurations are changed in an unauthorized manner./,
                     @test_result_file2.benchmark.value_definitions.first.description)
      end

      test 'type' do
        assert_equal("string", @test_result_file2.benchmark.value_definitions[0].type)
        assert_equal("string", @test_result_file2.benchmark.value_definitions[1].type)
        assert_equal("number", @test_result_file2.benchmark.value_definitions[4].type)
      end

      test 'lower bound' do
        assert_equal(nil, @test_result_file2.benchmark.value_definitions[0].lower_bound)
        assert_equal("0", @test_result_file2.benchmark.value_definitions[4].lower_bound)
      end

      test 'upper bound' do
        assert_equal(nil, @test_result_file2.benchmark.value_definitions[0].upper_bound)
        assert_equal("40000000", @test_result_file2.benchmark.value_definitions[4].upper_bound)
      end

      test 'default value' do
        assert_equal("51882M", @test_result_file2.benchmark.value_definitions[0].default_value)
        assert_equal("512M", @test_result_file2.benchmark.value_definitions[1].default_value)
        assert_equal("3h", @test_result_file2.benchmark.value_definitions[2].default_value)
        assert_equal("DEFAULT", @test_result_file2.benchmark.value_definitions[3].default_value)
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

    context 'fixes' do
      test 'should parse fixes for xccdf report' do
        parse_fixes @test_result_file
      end

      test 'should parse fixes for arf report' do
        parse_fixes @arf_result_file
      end

      test 'should parse multiple fixes for one rule' do
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_ensure_gpgcheck_globally_activated" }
        fixes = rule.fixes
        assert_equal 2, fixes.count
        assert fixes.map(&:id).all? { |id| id == 'ensure_gpgcheck_globally_activated' }
        refute_equal fixes.first.system, fixes.last.system
      end

      test "should parse one sub for fix" do
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_ensure_gpgcheck_globally_activated" }
        fix = rule.fixes.find { |fix| !fix.subs.empty? }
        assert_equal 1, fix.subs.count
        assert fix.subs.first.id
        assert fix.subs.first.text
      end

      test "should parse attributes for fix" do
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_enable_selinux_bootloader" }
        fix = rule.fixes.find { |fx| fx.system == "urn:xccdf:fix:script:sh" }
        assert_empty fix.subs
        assert fix.text
        assert fix.complexity
        assert fix.disruption
        assert fix.strategy
      end

      test "should parse multiple subs for fix" do
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_selinux_state" }
        fix = rule.fixes.find { |fix| !fix.subs.empty? }
        assert_equal 2, fix.subs.count
        sub = fix.subs.last
        assert sub.id
        assert sub.text
        assert sub.use
      end

      test "should resolve set-values for subs" do
        set_values = @arf_result_file.test_result.set_values
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_selinux_state" }
        rule.fixes.first.map_child_nodes(set_values).all? { |node| node.is_a? Nokogiri::XML::Text }
      end

      test "should parse full fix text lines" do
        set_values = @arf_result_file.test_result.set_values
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_selinux_state" }
        assert_equal 5, rule.fixes.first.full_text_lines(set_values).count
      end

      test "should compose full fix" do
        set_values = @arf_result_file.test_result.set_values
        rule = @arf_result_file.benchmark.rules.find { |rule| rule.id == "xccdf_org.ssgproject.content_rule_selinux_state" }
        assert_equal file_fixture('selinux_full_fix.sh').read, rule.fixes.first.full_text(set_values)
      end
    end
  end

  private

  def parse_fixes(result_file)
    fixes = result_file.benchmark.rules.flat_map(&:fixes).map(&:to_h)
    ids = fixes.map { |fix| fix[:id] }
    systems = fixes.map { |fix| fix[:system] }
    refute_empty fixes
    assert_equal ids, ids.compact
    assert_equal systems, systems.compact
  end

  def parse_set_values(result_file)
    set_values = result_file.test_result.set_values.map(&:to_h)
    idrefs = set_values.map { |val| val[:id] }
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
