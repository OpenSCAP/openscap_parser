# frozen_string_literal: true
require 'openscap_parser/xml_node'

module OpenscapParser
  class Sub < XmlNode
    def id
      @id ||= @parsed_xml['idref']
    end

    def to_h
      { :id => id, :text => text }
    end
  end
end
