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
  end
end
