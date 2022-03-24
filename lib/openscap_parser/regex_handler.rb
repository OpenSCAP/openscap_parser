# frozen_string_literal: true

module OpenscapParser
  class RegexHandler < XmlNode
    def self.regex node_set, regex
      node_set.find_all { |node| node.to_s =~ /#{regex}/ }
    end
  end
end
