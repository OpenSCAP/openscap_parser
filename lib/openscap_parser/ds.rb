# frozen_string_literal: true
require 'openscap_parser/xml_file'

module OpenscapParser
  class Ds
    include OpenscapParser::XmlFile

    def initialize(report)
      report_xml report
    end

    def profiles
      @profiles ||= profile_nodes
    end

    private

    def profile_nodes
      @report_xml.xpath(".//Profile").map do |node|
        id = node.attribute('id')&.value
        title = node.at_xpath('./title')&.text
        description = node.at_xpath('./description')&.text
        { :id => id, :title => title, :description => description }
      end
    end
  end
end
