# frozen_string_literal: true

require 'test_helper'
require 'ssg/downloader'

module Ssg
  class DownloaderTest < MiniTest::Test
    context 'fetch_datastream_file' do
      test 'returns the fetched file' do
        FILE = 'scap-security-guide-0.0.0.zip'
        uri = URI("https://example.com/#{FILE}")
        downloader = Downloader.new
        downloader.expects(:datastream_uri)
                  .at_least_once.returns(uri)
        downloader.expects(:get_chunked).with uri

        assert_equal FILE, downloader.fetch_datastream_file
      end
    end
  end
end
