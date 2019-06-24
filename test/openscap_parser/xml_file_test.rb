# frozen_string_literal: true

require 'test_helper'

class XmlFileTest < Minitest::Test
  include OpenscapParser::XmlFile

  def setup
    @invalid_report = file_fixture('invalid_report.xml').read
    @valid_report = file_fixture('xccdf_report.xml').read
  end

  test 'report_xml parses a valid XML report' do
    assert_equal report_xml(@valid_report).class, Nokogiri::XML::Document
  end

  test 'report_xml handles an invalid XML report' do
    assert_raises Nokogiri::XML::SyntaxError do
      report_xml(@invalid_report)
    end
  end
end
