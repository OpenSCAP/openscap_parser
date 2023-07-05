# frozen_string_literal: true

require 'test_helper'
require 'ssg/unarchiver'

module Ssg
  class UnarchiverTest < MiniTest::Test
    context 'datastream_files' do
      test 'properly shells out to unzip' do
        ZIP_FILE = 'scap-security-guide-0.0.0.zip'
        DATASTREAMS = ['rhel6'].freeze
        FILES = [].freeze
        unarchiver = Unarchiver.new(ZIP_FILE, DATASTREAMS)
        unarchiver.expects(:system).with(
          'unzip', '-o',
          'scap-security-guide-0.0.0.zip',
          'scap-security-guide-0.0.0/ssg-rhel6-ds.xml'
        ).returns(true)

        assert_equal ['scap-security-guide-0.0.0/ssg-rhel6-ds.xml'],
                     unarchiver.datastream_files
      end
    end
  end
end
