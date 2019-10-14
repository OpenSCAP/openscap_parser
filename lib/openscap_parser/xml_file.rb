# frozen_string_literal: true

require 'nokogiri'
require 'openscap_parser/xml_node'

module OpenscapParser
  class XmlFile < XmlNode

    def initialize(raw_xml)
      parsed_xml(raw_xml)
    end
  end
end
