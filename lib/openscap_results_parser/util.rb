# frozen_string_literal: true

# Utility functions for OpenscapParser
module OpenscapParser
  module Util
    def newline_to_whitespace(string)
      string.gsub(/ *\n+/, " ").strip
    end
  end
end
