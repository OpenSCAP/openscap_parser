# frozen_string_literal: true
require 'nokogiri'

module OpenscapParser
  module XmlFile
    attr_reader :namespaces

    def report_xml(report_contents = '')
      @report_xml ||= ::Nokogiri::XML.parse(
        report_contents, nil, nil, Nokogiri::XML::ParseOptions.new.norecover)
      @namespaces = @report_xml.namespaces.clone
      @report_xml.remove_namespaces!
    end
  end
end
