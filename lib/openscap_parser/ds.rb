# frozen_string_literal: true
require 'openscap_parser/xml_file'

module OpenscapParser
  class Ds
    include OpenscapParser::XmlFile

    def initialize(report)
      parsed_xml report
    end

    def profiles
      @profiles ||= profile_nodes
    end

    def valid?
      return true if @parsed_xml.root.name == 'data-stream-collection' && namespaces.keys.include?('xmlns:ds')
      return true if @parsed_xml.root.name == 'Tailoring' && namespaces.keys.include?('xmlns:xccdf')
      false
    end

    private

    def profile_nodes
      @parsed_xml.xpath(".//Profile").map do |node|
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
