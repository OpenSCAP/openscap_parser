# frozen_string_literal: true

require 'nokogiri'

module OpenscapParser
  # Represents a generic Xml node with parsed_xml
  class XmlNode
    attr_reader :namespaces

    def initialize(parsed_xml: nil)
      @parsed_xml = parsed_xml
    end

    def parsed_xml(report_contents = '')
      return @parsed_xml if @parsed_xml
      @parsed_xml = ::Nokogiri::XML.parse(
        report_contents, nil, nil, Nokogiri::XML::ParseOptions.new.norecover)
      @namespaces = @parsed_xml.namespaces.clone
      @parsed_xml.remove_namespaces!
    end

    def text
      @parsed_xml.text
    end

    def xpath_node(xpath)
      parsed_xml && parsed_xml.at_xpath(xpath)
    end
    alias :at_xpath :xpath_node

    def xpath_nodes(xpath)
      parsed_xml && parsed_xml.xpath(xpath) || []
    end
    alias :xpath :xpath_nodes
  end
end
