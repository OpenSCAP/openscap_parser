# frozen_string_literal: true

require 'test_helper'

class TailoringFileTest < MiniTest::Test
  context 'format validations' do
    should 'recognize tailoring file as valid' do
      tailoring_file = OpenscapParser::TailoringFile.new(
        file_fixture('ssg-rhel7-ds-tailoring.xml').read
      )
      assert(tailoring_file.valid?)
    end
  end
end
