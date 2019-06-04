# frozen_string_literal: true
require 'nokogiri'

module OpenscapParser
  # Methods related with parsing directly the XML from the Report
  # as opposed to using the OpenSCAP APIs
  module XMLReport
    def self.included(base)
      base.class_eval do
        def host
          @report_xml.search('target').text
        end

        def description
          @report_xml.search('description').first.text
        end

        def report_xml(report_contents = '')
          @report_xml ||= ::Nokogiri::XML.parse(report_contents)
          @report_xml.remove_namespaces! if @report_xml.namespaces.keys.include? 'xmlns:arf'
        end
      end
    end
  end
end
