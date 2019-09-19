# frozen_string_literal: true
require 'openscap_parser/xml_file'

module OpenscapParser
  class Ds
    include OpenscapParser::XmlFile
    include OpenscapParser::Rules
    include OpenscapParser::Profiles

    def initialize(report)
      parsed_xml report
    end

    def valid?
      return true if @parsed_xml.root.name == 'data-stream-collection' && namespaces.keys.include?('xmlns:ds')
      return true if @parsed_xml.root.name == 'Tailoring' && namespaces.keys.include?('xmlns:xccdf')
      false
    end
  end
end
