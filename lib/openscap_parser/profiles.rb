# frozen_string_literal: true

module OpenscapParser
  # Methods related to saving profiles and finding which hosts
  # they belong to
  module Profiles
    def self.included(base)
      base.class_eval do
        def profiles
          @profiles ||= profile_nodes.inject({}) do |profiles, profile_node|
            profiles[profile_node['id']] = profile_node.at_css('title').text

            profiles
          end
        end

        def profile_nodes(xpath = ".//Profile")
          xpath_nodes(xpath)
        end
      end
    end
  end
end
