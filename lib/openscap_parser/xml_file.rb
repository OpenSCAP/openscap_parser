# frozen_string_literal: true

require 'nokogiri'
require 'openscap_parser/xml_node'

module OpenscapParser
  # Represents methods used to initialize xml file
  class XmlFile < XmlNode
    def initialize(raw_xml)
      parsed_xml(raw_xml)
    end
  end
end
