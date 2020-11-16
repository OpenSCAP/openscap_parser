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
end
