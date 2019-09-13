# frozen_string_literal: true

require 'json'
require 'net/http'

module Ssg
  # Downloads SCAP datastreams from the SCAP Security Guide
  # https://github.com/ComplianceAsCode/content
  class Downloader
    RELEASES_API = 'https://api.github.com/repos'\
                             '/ComplianceAsCode/content/releases/'
    SSG_DS_REGEX = /scap-security-guide-(\d+\.)+zip$/

    def initialize(version = 'latest')
      @release_uri = URI(
        "#{RELEASES_API}#{'tags/' unless version[/^latest$/]}#{version}"
      )
    end

    def self.download!(versions = [])
      versions.uniq.map do |version|
        [version, new(version).fetch_datastream_file]
      end.to_h
    end

    def fetch_datastream_file
      puts "Fetching #{datastream_filename}"
      get_chunked(datastream_uri)

      datastream_filename
    end

    private

    def datastream_uri
      @datastream_uri ||= URI(
        download_urls.find { |url| url[SSG_DS_REGEX] }
      )
    end

    def download_urls
      get_json(@release_uri).dig('assets').map do |asset|
        asset.dig('browser_download_url')
      end
    end

    def fetch(request, &block)
      Net::HTTP.start(
        request.uri.host, request.uri.port,
        use_ssl: request.uri.scheme['https']
      ) do |http|
        check_response(http.request(request, &block), &block)
      end
    end

    def get(uri, &block)
      fetch(Net::HTTP::Get.new(uri), &block)
    end

    def head(uri, &block)
      fetch(Net::HTTP::Head.new(uri), &block)
    end

    def check_response(response, &block)
      case response
      when Net::HTTPSuccess
        response
      when Net::HTTPRedirection
        get(URI(response['location']), &block)
      else
        response.value
      end
    end

    def get_chunked(uri, filename: datastream_filename)
      head(uri) do |response|
        next unless Net::HTTPSuccess === response
        open(filename, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end
    end

    def datastream_filename
      datastream_uri.path.split('/').last[SSG_DS_REGEX]
    end

    def get_json(uri)
      JSON.parse(get(uri).body)
    end
  end
end
