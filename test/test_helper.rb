$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "openscap_parser"
require 'pathname'

require "minitest/autorun"
require 'shoulda-context'

def test(name, &block)
  test_name = "test_#{name.gsub(/\s+/, '_')}".to_sym
  defined = method_defined? test_name
  raise "#{test_name} is already defined in #{self}" if defined
  if block_given?
    define_method(test_name, &block)
  else
    define_method(test_name) do
      flunk "No implementation provided for #{name}"
    end
  end
end

def file_fixture(fixture_name)
  file_fixture_path = './test/fixtures/files'
  path = Pathname.new(File.join(file_fixture_path, fixture_name))

  if path.exist?
    path
  else
    msg = "the directory '%s' does not contain a file named '%s'"
    raise ArgumentError, msg % [file_fixture_path, fixture_name]
  end
end
