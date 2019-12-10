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
      @selected_rule_ids ||= @parsed_xml.xpath("select[@selected='true']/@idref") &&
        @parsed_xml.xpath("select[@selected='true']/@idref").map(&:text)
    end

    def to_h
      { :id => id, :title => title, :description => description }
    end
  end
end
