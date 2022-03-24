require 'openscap_parser/regex_handler'

module OpenscapParser
  class Profile < XmlNode
    def id
      @id ||= @parsed_xml['id']
    end

    def extends_profile_id
      @extends ||= @parsed_xml['extends']
    end

    def title
      @title ||= @parsed_xml.at_css('title') &&
        @parsed_xml.at_css('title').text
    end
    alias :name :title

    def description
      @description ||= @parsed_xml.at_css('description') &&
        @parsed_xml.at_css('description').text
    end

    def selected_rule_ids
      # Look for selected rule ids where the idref contains '_rule_' that is not preceded by 'group'
      @selected_rule_ids ||= @parsed_xml.xpath("select[@selected='true']
                                                      [regex(@idref, '^((?!_group_).)*?(_rule_).*$')]
                                                      /@idref", RegexHandler) &&
                             @parsed_xml.xpath("select[@selected='true']
                                                      [regex(@idref, '^((?!_group_).)*?(_rule_).*$')]
                                                      /@idref", RegexHandler).map(&:text)
    end

    def selected_group_ids
      # Look for selected group ids where the idref contains '_group_' that is not preceded by 'rule'
      @selected_group_ids ||= @parsed_xml.xpath("select[@selected='true']
                                                       [regex(@idref, '^((?!_rule_).)*?(_group_).*$')]
                                                       /@idref", RegexHandler) &&
                              @parsed_xml.xpath("select[@selected='true']
                                                       [regex(@idref, '^((?!_rule_).)*?(_group_).*$')]
                                                       /@idref", RegexHandler).map(&:text)
    end

    def selected_entity_ids
      @selected_entity_ids ||= @parsed_xml.xpath("select[@selected='true']/@idref") &&
        @parsed_xml.xpath("select[@selected='true']/@idref").map(&:text)
    end

    def to_h
      { :id => id, :title => title, :description => description }
    end
  end
end
