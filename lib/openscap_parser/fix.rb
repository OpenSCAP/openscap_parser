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

    def disruption
      @disruption ||= @parsed_xml['disruption']
    end

    def strategy
      @strategy ||= @parsed_xml['strategy']
    end

    def to_h
      {
        :id => id,
        :system => system,
        :complexity => complexity,
        :disruption => disruption,
        :strategy => strategy,
        :text => text,
        :subs => subs.map(&:to_h)
      }
    end
  end
end
