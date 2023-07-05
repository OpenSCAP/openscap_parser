# frozen_string_literal: true

module OpenscapParser
  # A class for parsing RuleResult information
  class RuleResult < XmlNode
    def id
      @id ||= parsed_xml['idref']
    end

    def time
      @time ||= parsed_xml['time']
    end

    def severity
      @severity ||= parsed_xml['severity']
    end

    def weight
      @weight ||= parsed_xml['weight']
    end

    def result
      @result ||= parsed_xml.at_xpath('result')&.text || ''
    end

    def to_h
      {
        id:,
        time:,
        severity:,
        weight:,
        result:
      }
    end
  end
end
