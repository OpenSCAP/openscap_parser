# frozen_string_literal: true

require 'test_helper'

class XmlFileTest < Minitest::Test
  include OpenscapParser::XmlFile

  def setup
    @invalid_report = file_fixture('invalid_report.xml').read
    @valid_report = file_fixture('xccdf_report.xml').read
  end

  test 'parsed_xml parses a valid XML report' do
    assert_equal parsed_xml(@valid_report).class, Nokogiri::XML::Document
  end

  test 'parsed_xml handles an invalid XML report' do
    assert_raises Nokogiri::XML::SyntaxError do
      parsed_xml(@invalid_report)
    end
  end
end
