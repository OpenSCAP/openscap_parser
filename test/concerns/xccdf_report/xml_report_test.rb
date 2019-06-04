# frozen_string_literal: true

require 'test_helper'

class XMLReportTest < Minitest::Test
  include OpenscapParser::XMLReport

  def setup
    report_xml(file_fixture('xccdf_report.xml').read)
  end

  test 'report_xml parses the XML report' do
    assert_equal @report_xml.class, Nokogiri::XML::Document
  end

  test 'report_description' do
    assert_match(/^This guide presents/, description)
  end

  test 'report_host' do
    assert_match host, 'lenovolobato.lobatolan.home'
  end
end
