# frozen_string_literal: true

desc 'Import or update SCAP datastreams from the SCAP Security Guide'
namespace :ssg do
  desc 'Import or update SCAP datastreams for RHEL 6, 7, and 8'
  task :sync_rhel do |_task|
    RHEL_SSG_VERSIONS =
      'v0.1.28:rhel6,' \
      'v0.1.43:rhel7,' \
      'v0.1.42:rhel8'

    ENV['DATASTREAMS'] = RHEL_SSG_VERSIONS
    Rake::Task['ssg:sync'].invoke
  end

  desc 'Import or update SCAP datastreams, ' \
    'provided as a comma separated list: ' \
    '`rake ssg:sync DATASTREAMS=v0.1.43:rhel7,latest:fedora`'
  task :sync do |_task|
    DATASTREAMS = ENV.fetch('DATASTREAMS', '').split(',')
                     .each_with_object({}) do |arg, datastreams|
      version, datastream = arg.split(':')
      datastreams[version] = (datastreams[version] || []).push(datastream)
    end

    require 'ssg'

    ds_zip_filenames = Ssg::Downloader.download!(DATASTREAMS.keys)
    DATASTREAM_FILENAMES = Ssg::Unarchiver
                           .unarchive!(ds_zip_filenames, DATASTREAMS)
  end
end
