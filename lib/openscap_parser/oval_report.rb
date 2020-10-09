# frozen_string_literal: true
require 'openscap_parser/xml_file'
require 'oval/definition_result'

module OpenscapParser
  class OvalReport < XmlFile
    def definition_results
      @definition_results ||= definition_result_nodes.map { |node| ::Oval::DefinitionResult.new parsed_xml: node }
    end

    def definition_result_nodes(xpath = "./oval_results/results/system/definitions/definition")
      xpath_nodes(xpath)
    end
  end
end
