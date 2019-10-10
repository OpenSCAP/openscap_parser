module OpenscapParser
  class Profile
    def initialize(profile_xml: nil)
      @profile_xml = profile_xml
    end

    def id
      @id ||= @profile_xml['id']
    end

    def title
      @title ||= @profile_xml.at_css('title') &&
        @profile_xml.at_css('title').text
    end

    def description
      @description ||= @profile_xml.at_css('description') &&
        @profile_xml.at_css('description').text
    end

    def selected_rule_ids
      id_refs = @profile_xml.xpath("select[@selected='true']/@idref")
      id_refs && id_refs.map(&:text)
    end

    def to_h
      { :id => id, :title => title, :description => description }
    end
  end
end
