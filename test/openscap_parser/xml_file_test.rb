# frozen_string_literal: true

require 'test_helper'

class XmlFileTest < Minitest::Test
  def setup
    @invalid_report = file_fixture('invalid_report.xml').read
    @valid_report = file_fixture('xccdf_report.xml').read
  end

  test 'parsed_xml parses a valid XML report' do
    assert_equal OpenscapParser::XmlFile.new(@valid_report).parsed_xml.class,
      Nokogiri::XML::Document
  end

  test 'parsed_xml handles an invalid XML report' do
    assert_raises Nokogiri::XML::SyntaxError do
      OpenscapParser::XmlFile.new(file_fixture('invalid_report.xml').read)
    end
  end
end
