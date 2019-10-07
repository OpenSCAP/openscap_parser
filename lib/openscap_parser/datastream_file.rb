# frozen_string_literal: true
require 'openscap_parser/xml_file'
require 'openscap_parser/benchmarks'

module OpenscapParser
  # A class to represent a datastream (-ds.xml) XmlFile
  class DatastreamFile < XmlFile
    include OpenscapParser::Benchmarks

    def valid?
      return true if @parsed_xml.root.name == 'data-stream-collection' && namespaces.keys.include?('xmlns:ds')
      false
    end
  end
end
