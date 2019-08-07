# frozen_string_literal: true
require 'test_helper'

class DsTest < MiniTest::Test
  context 'scap content' do
    should 'be able to parse profiles' do
      parser = create_parser('ssg-rhel7-ds.xml')
      profile_titles = [
        "United States Government Configuration Baseline",
        "Standard System Security Profile for Red Hat Enterprise Linux 7",
        "Criminal Justice Information Services (CJIS) Security Policy",
        "C2S for Red Hat Enterprise Linux 7",
        "Health Insurance Portability and Accountability Act (HIPAA)",
        "Unclassified Information in Non-federal Information Systems and Organizations (NIST 800-171)",
        "DISA STIG for Red Hat Enterprise Linux 7",
        "OSPP - Protection Profile for General Purpose Operating Systems v. 4.2",
        "PCI-DSS v3 Control Baseline for Red Hat Enterprise Linux 7",
        "Red Hat Corporate Profile for Certified Cloud Providers (RH CCP)",
        "PCI-DSS v3 Control Baseline for Red Hat Enterprise Linux 7"
      ]
      assert_equal(profile_titles, parser.profiles.map { |profile| profile[:title] })
    end
  end

  context 'tailoring file' do
    should 'be able to parse profiles' do
      parser = create_parser('ssg-rhel7-ds-tailoring.xml')
      profile_titles = [
        "Standard System Security Profile [CUSTOMIZED]",
        "Common Profile for General-Purpose Systems [CUSTOMIZED]"
      ]
      assert_equal(profile_titles, parser.profiles.map { |profile| profile[:title] })
    end
  end

  context 'format validations' do
    should 'remember the namespaces after removing them' do
      refute_empty(create_parser('ssg-rhel7-ds.xml').namespaces)
    end

    should 'recognize scap content as valid' do
      assert(create_parser('ssg-rhel7-ds.xml').valid?)
    end

    should 'recognize tailoring file as valid' do
      assert(create_parser('ssg-rhel7-ds-tailoring.xml').valid?)
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
    ::OpenscapParser::Ds.new(scap_content)
  end
end
