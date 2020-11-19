require "openscap_parser/xml_node"

module Oval
  class Reference < ::OpenscapParser::XmlNode
    def source
      @source ||= @parsed_xml['source']
    end

    def ref_id
      @ref_id ||= @parsed_xml['ref_id']
    end

    def ref_url
      @ref_url ||= @parsed_xml['ref_url']
    end

    def to_h
      { :source => source, :ref_id => ref_id, :ref_url => ref_url }
    end
  end
end
