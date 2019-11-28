# frozen_string_literal: true

require 'openscap_parser/sub'

module OpenscapParser
  module Subs
    def self.included(base)
      base.class_eval do
        def sub
          return unless sub_node
          Sub.new(parsed_xml: sub_node)
        end

        def sub_node
          @sub_node ||= xpath_node('.//sub')
        end
      end
    end
  end
end
