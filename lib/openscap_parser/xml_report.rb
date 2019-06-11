# frozen_string_literal: true
require 'nokogiri'
require 'openscap_parser/xml_file'

module OpenscapParser
  # Methods related with parsing directly the XML from the Report
  # as opposed to using the OpenSCAP APIs
  module XMLReport
    def self.included(base)
      base.class_eval do
        include OpenscapParser::XmlFile

        def host
          @report_xml.search('target').text
        end

        def description
          @report_xml.search('description').first.text
        end
      end
    end
  end
end
