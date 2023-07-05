# frozen_string_literal: true

require 'openscap_parser/xml_node'

module OpenscapParser
  # A class for parsing SetValue information
  class SetValue < XmlNode
    def id
      @id ||= @parsed_xml['idref']
    end

    def text
      @text ||= @parsed_xml.text
    end

    def to_h
      { id:, text: }
    end
  end
end
