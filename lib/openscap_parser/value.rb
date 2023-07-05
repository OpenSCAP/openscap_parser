# frozen_string_literal: true
module OpenscapParser
  class Value < XmlNode
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

    def generic_selector(type, selector = nil)
      cache = instance_variable_get("@#{type}")

      unless cache
        element_name = type.to_s.sub('_', '-')

        cache = parsed_xml.xpath(element_name).each_with_object({}) do |element, elements|
          elements[element.at_xpath('@selector')&.text] = element&.text
        end
        instance_variable_set("@#{type}", cache)
      end

      return cache[selector] if selector

      cache[nil] || cache[''] || cache.values.first
    end

    def upper_bound(selector = nil)
      generic_selector(:upper_bound, selector)
    end

    def lower_bound(selector = nil)
      generic_selector(:lower_bound, selector)
    end

    def value(selector = nil)
      generic_selector(:value, selector)
    end

    def to_h
      {
        :id => id,
        :title => title,
        :description => description,
        :type => type,
        :lower_bound => lower_bound,
        :upper_bound => upper_bound
      }
    end
  end
end
