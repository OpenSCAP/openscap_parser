# frozen_string_literal: true

module OpenscapParser
  class RuleResult
    attr_accessor :id, :result

    def to_h
      { :id => id, :result => result }
    end
  end
end
