# frozen_string_literal: true
require 'openscap_parser/xml_node'
require 'openscap_parser/subs'

module OpenscapParser
  class Fix < XmlNode
    include OpenscapParser::Subs

    def id
      @id ||= @parsed_xml['id']
    end

    def system
      @system ||= @parsed_xml['system']
    end

    def complexity
      @complexity ||= @parsed_xml['complexity']
    end

    def text
      @parsed_xml.text unless sub
    end

    def to_h
      {
        :id => id,
        :system => system,
        :complexity => complexity,
        :text => text,
        :sub => sub.to_h
      }
    end
  end
end
