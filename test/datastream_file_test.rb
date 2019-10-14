# frozen_string_literal: true

require 'test_helper'

class DatastreamFileTest < MiniTest::Test
  context 'scap content' do
    should 'be able to parse profiles' do
      parser = create_parser('ssg-rhel7-ds.xml')
      profile_ref_ids = [
        "xccdf_org.ssgproject.content_profile_standard",
        "xccdf_org.ssgproject.content_profile_nist-800-171-cui",
        "xccdf_org.ssgproject.content_profile_rht-ccp",
        "xccdf_org.ssgproject.content_profile_C2S",
        "xccdf_org.ssgproject.content_profile_cjis",
        "xccdf_org.ssgproject.content_profile_hipaa",
        "xccdf_org.ssgproject.content_profile_ospp",
        "xccdf_org.ssgproject.content_profile_ospp42",
        "xccdf_org.ssgproject.content_profile_pci-dss",
        "xccdf_org.ssgproject.content_profile_stig-rhel7-disa",
        "xccdf_org.ssgproject.content_profile_rhelh-vpp"
      ]
      assert_equal(profile_ref_ids, parser.benchmark.profiles.map { |profile| profile.id })
    end
  end

  context 'format validations' do
    should 'remember the namespaces after removing them' do
      refute_empty(create_parser('ssg-rhel7-ds.xml').namespaces)
    end

    should 'recognize scap content as valid' do
      assert(create_parser('ssg-rhel7-ds.xml').valid?)
    end

    should 'not recognize random file as valid' do
      assert_raises Nokogiri::XML::SyntaxError do
        create_parser('invalid_report.xml')
      end
    end

    should 'not recognize xccdf report as valid ds file' do
      refute(create_parser('rhel-xccdf-report.xml').valid?)
    end
  end

  def create_parser(file)
    scap_content = file_fixture(file).read
    ::OpenscapParser::DatastreamFile.new(scap_content)
  end
end
