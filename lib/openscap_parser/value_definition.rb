# frozen_string_literal: true
module OpenscapParser
  class ValueDefinition < XmlNode
    include OpenscapParser::Util

    def id
      @id ||= parsed_xml['id']
    end

    def description
      @description ||= newline_to_whitespace(parsed_xml.at_css('description')&.text)
    end

    def title
      @title ||= parsed_xml.at_css('title')&.text
    end

    def type
      @type ||= parsed_xml['type'] || 'string'
    end

    def lower_bound
      @lower_bound ||= begin
        lower_bound_element = parsed_xml.at_xpath("lower-bound[@selector='']") || parsed_xml.at_xpath('lower-bound[not(@selector)]')
        lower_bound_element&.text
      end
    end

    def upper_bound
      @upper_bound ||= begin
        upper_bound_element = parsed_xml.at_xpath("upper-bound[@selector='']") || parsed_xml.at_xpath('upper-bound[not(@selector)]')
        upper_bound_element&.text
      end
    end

    def default_value
      # The default value is the value element with a empty or absent @selector
      # If there is no value element with an empty or absent @selector, the first value in
      # the top down processing shall be the default element
      @default_value ||= begin
        value_element = parsed_xml.at_xpath("value[@selector='']") || parsed_xml.at_xpath('value[not(@selector)]') || parsed_xml.xpath("value")[0]
        value_element&.text
      end
    end

    def to_h
      {
        :id => id,
        :title => title,
        :description => description,
        :type => type,
        :lower_bound => lower_bound,
        :upper_bound => upper_bound,
        :default_value => default_value
      }
    end
  end
end
