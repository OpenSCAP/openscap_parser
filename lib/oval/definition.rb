require "openscap_parser/xml_node"
require "oval/reference"

module Oval
  class Definition < ::OpenscapParser::XmlNode
    def id
      @id ||= @parsed_xml['id']
    end

    def version
      @version ||= @parsed_xml['version']
    end

    def klass
      @klass ||= @parsed_xml['class']
    end

    def title
      xml = @parsed_xml.at_xpath("./metadata/title")
      @title ||= xml && xml.text
    end

    def description
      xml = @parsed_xml.at_xpath("./metadata/description")
      @description ||= xml && xml.text
    end

    def reference_nodes
      @reference_nodes ||= @parsed_xml.xpath("./metadata/reference")
    end

    def references
      @references ||= reference_nodes.map { |node| Reference.new parsed_xml: node }
    end

    def to_h
      {
        :id => id,
        :version => version,
        :klass => klass,
        :title => title,
        :description => description,
        :references => references.map(&:to_h)
      }
    end
  end
end
