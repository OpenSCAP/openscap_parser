# frozen_string_literal: true
require 'nokogiri'

module OpenscapParser
  module XmlFile
    attr_reader :namespaces

    def parsed_xml(report_contents = '')
      @parsed_xml ||= ::Nokogiri::XML.parse(
        report_contents, nil, nil, Nokogiri::XML::ParseOptions.new.norecover)
      @namespaces = @parsed_xml.namespaces.clone
      @parsed_xml.remove_namespaces!
    end

    def xpath_node(xpath)
      @parsed_xml && @parsed_xml.at_xpath(xpath)
    end

    def xpath_nodes(xpath)
      @parsed_xml && @parsed_xml.xpath(xpath) || []
    end
  end
end
