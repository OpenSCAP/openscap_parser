# frozen_string_literal: true

# Mimics openscap-ruby Rule interface
module OpenscapParser
  class Tailoring < XmlNode
    include OpenscapParser::Profiles

    def id
      @id ||= @parsed_xml['id']
    end

    def benchmark
      @benchmark ||= @parsed_xml.at_xpath('benchmark/@href') &&
        @parsed_xml.at_xpath('benchmark/@href').text
    end

    def version
      @version ||= @parsed_xml.at_xpath('version') &&
        @parsed_xml.at_xpath('version').text
    end

    def version_time
      @version_time ||= @parsed_xml.at_xpath('version/@time') &&
        @parsed_xml.at_xpath('version/@time').text
    end
  end
end
