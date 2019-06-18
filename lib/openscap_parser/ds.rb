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
        id_node = node.attribute('id')
        id = id_node.value if id_node
        title_node = node.at_xpath('./title')
        title = title_node.text if title_node
        desc_node = node.at_xpath('./description')
        description = desc_node.text if desc_node
        { :id => id, :title => title, :description => description }
      end
    end
  end
end
