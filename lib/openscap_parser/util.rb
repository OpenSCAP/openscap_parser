# frozen_string_literal: true

module OpenscapParser
  # Utility functions for OpenscapParser
  module Util
    def newline_to_whitespace(string)
      string.gsub(/ *\n+/, ' ').strip
    end
  end
end
