# frozen_string_literal: true

require 'test_helper'

class OvalReportTest < Minitest::Test
  def setup
    @valid_report = file_fixture('fedora_oval_report.xml').read
    @invalid_report = file_fixture('xccdf_report.xml').read
  end

  test 'should parse definition results' do
    results = OpenscapParser::OvalReport.new(@valid_report).definition_results
    refute results.empty?
    assert results.last.definition_id
    assert results.last.result
  end

  test 'should return no results for invalid file' do
    results = OpenscapParser::OvalReport.new(@invalid_report).definition_results
    assert results.empty?
  end

  test 'should parse definitions' do
    defs = OpenscapParser::OvalReport.new(@valid_report).definitions
    refute defs.empty?
    assert defs.last.id
    assert defs.last.title
    assert defs.last.description
    refute_empty defs.last.references
  end

  test 'should return no definitions for invalid file' do
    defs = OpenscapParser::OvalReport.new(@invalid_report).definitions
    assert defs.empty?
  end
end
