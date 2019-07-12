# frozen_string_literal: true
require 'openscap_parser/xml_file'

module OpenscapParser
  class Arf
    include OpenscapParser::XmlFile
    include OpenscapParser::Rules
    include OpenscapParser::RuleResults

    def initialize(report)
      report_xml report
    end

    def valid?
      @report_xml.root.name == 'asset-report-collection' && namespaces.keys.include?('xmlns:arf')
    end
  end
end
