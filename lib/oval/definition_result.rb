require 'openscap_parser/xml_node'

module Oval
  class DefinitionResult < ::OpenscapParser::XmlNode
    def definition_id
      @definition_id ||= @parsed_xml['definition_id']
    end

    def result
      @result ||= @parsed_xml['result']
    end

    def to_h
      { :id => definition_id, :result => result }
    end
  end
end
