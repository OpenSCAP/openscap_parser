# frozen_string_literal: true

require 'openscap_parser/xml_node'

module OpenscapParser
  # A class for parsing Sub information
  class Sub < XmlNode
    def id
      @id ||= @parsed_xml['idref']
    end

    def use
      @use ||= @parsed_xml['use']
    end

    def to_h
      { id:, text:, use: }
    end
  end
end
