# frozen_string_literal: true

require 'openscap_parser/profile'

module OpenscapParser
  # Methods related to saving profiles and finding which hosts
  # they belong to
  module Profiles
    def self.included(base)
      base.class_eval do
        def profiles
          @profiles ||= profile_nodes.map do |profile_node|
            OpenscapParser::Profile.new(parsed_xml: profile_node)
          end
        end

        def profile_nodes(xpath = ".//Profile")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
