# lib/railtie.rb
require 'openscap_parser'

if defined?(Rails)
  module OpenscapParser
    class Railtie < Rails::Railtie
      railtie_name :openscap_parser

      rake_tasks do
        path = File.expand_path(__dir__)
        Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
      end
    end
  end
end
