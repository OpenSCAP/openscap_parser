# frozen_string_literal: true

require 'openscap_parser/tailorings'

module OpenscapParser
  # A class to represent a tailoring XmlFile
  class TailoringFile < XmlFile
    include OpenscapParser::Tailorings

    def valid?
      return true if @parsed_xml.root.name == 'Tailoring' && namespaces.keys.include?('xmlns:xccdf')
      false
    end
  end
end
