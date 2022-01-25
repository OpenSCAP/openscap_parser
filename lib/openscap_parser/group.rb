# frozen_string_literal: true
module OpenscapParser
  class Group < XmlNode
    include OpenscapParser::Util

    def id
      @id ||= parsed_xml['id']
    end

    def title
      @title ||= parsed_xml.at_css('title') &&
        parsed_xml.at_css('title').text
    end

    def description
      @description ||= newline_to_whitespace(
        parsed_xml.at_css('description') &&
          parsed_xml.at_css('description').text || ''
      )
    end

    def rationale
      @rationale ||= newline_to_whitespace(
        parsed_xml.at_css('rationale') &&
          parsed_xml.at_css('rationale').text || ''
      )
    end

    def requires
      @requires ||= parsed_xml.xpath('./requires') &&
        parsed_xml.xpath('./requires/@idref').flat_map do |r|
          r.to_s&.split
        end
    end

    def conflicts
      @conflicts ||= parsed_xml.xpath('./conflicts') &&
        parsed_xml.xpath('./conflicts/@idref').flat_map do |c|
          c.to_s&.split
        end
    end

    def selected
      @selected ||= parsed_xml['selected']
    end

    def parent_id
      @parent_id = parsed_xml.xpath('../@id').to_s
    end

    def parent_type
      if parsed_xml.xpath("name(..)='Group'")
        @parent_type = 'Group'
      else
        @parent_type = 'Benchmark'
      end
    end

    def to_h
      {
        :id => id,
        :title => title,
        :description => description,
        :requires => requires,
        :conflicts => conflicts,
        :rationale => rationale,
        :selected => selected,
        :parent_id => parent_id,
        :parent_type => parent_type
      }
    end
  end
end
