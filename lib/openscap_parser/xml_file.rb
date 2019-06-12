# frozen_string_literal: true
require 'nokogiri'

module OpenscapParser
  module XmlFile
    def report_xml(report_contents = '')
      @report_xml ||= ::Nokogiri::XML.parse(report_contents)
      @report_xml.remove_namespaces!
    end
  end
end
