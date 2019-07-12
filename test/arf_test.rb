# frozen_string_literal: true
require 'test_helper'

class ArfTest < MiniTest::Test
  def setup
    @centos = 'arf_report_centos_cs2.xml'
    @java = 'arf_report_java.xml'
    @firefox = 'arf_report_firefox.xml'
    @fixtures = [@centos, @java, @firefox]
  end

  context 'arf report' do
    should 'parse rule results' do
      parser = create_parser(@centos)
      assert_equal 837, parser.rule_results.count

      parser = create_parser(@firefox)
      assert_equal 28, parser.rule_results.count

      parser = create_parser(@java)
      assert_equal 11, parser.rule_results.count
    end

    should 'parse result and id for each rule result' do
      @fixtures.each do |fixture|
        parser = create_parser(fixture)
        assert parser.rule_results.map(&:result).all?
        assert parser.rule_results.map(&:id).all?
      end
    end

    should 'parse rules for each rule result' do
      @fixtures.each do |fixture|
        parser = create_parser(fixture)
        refute parser.rule_objects.empty?

        rules = parser.rule_objects.reduce({}) do |memo, rule_obj|
          memo[rule_obj.id] = rule_obj
          memo
        end

        assert parser.rule_results.map { |result| rules[result.id] }.all?
      end
    end

    should 'parse simple fixes' do
      parser = create_parser(@java)
      rule = parser.rule_objects.find { |rule| rule.id == 'xccdf_org.ssgproject.content_rule_java_jre_deployment_config_exists' }
      assert rule.fixes.first[:value].start_with?('JAVA_CONFIG="/etc/.java/deployment/deployment.config"')
      refute rule.fixes.first[:sub]
    end

    should 'parse fixes with sub' do
      parser = create_parser(@firefox)
      rule = parser.rule_objects.find { |rule| rule.id == 'xccdf_org.ssgproject.content_rule_firefox_preferences-lock_settings_obscure' }
      assert rule.fixes.first[:sub]
      assert rule.fixes.first[:sub][:idref]
      assert rule.fixes.first[:sub][:value]
    end

    should 'parse multiple fixes for one rule' do
      parser = create_parser(@centos)
      rule = parser.rule_objects.find { |rule| rule.id == 'xccdf_org.ssgproject.content_rule_package_aide_installed' }
      assert_equal 4, rule.fixes.count
      systems = %w(urn:xccdf:fix:script:sh urn:xccdf:fix:script:ansible urn:xccdf:fix:script:puppet urn:redhat:anaconda:pre).sort
      assert systems, rule.fixes.map { |fix| fix[:system] }.sort
      assert rule.fixes.map { |fix| fix[:value] }.all?
    end
  end

  def create_parser(file)
    scap_content = file_fixture(file).read
    ::OpenscapParser::Arf.new(scap_content)
  end
end
