module Ssg
  class Unarchiver
    UNZIP_CMD = ['unzip', '-o']

    def initialize(ds_zip_filename, datastreams)
      @ds_zip_filename = ds_zip_filename
      @datastreams = datastreams
    end

    def self.unarchive!(ds_zip_filenames, datastreams)
      ds_zip_filenames.map do |version, ds_zip_filename|
        new(ds_zip_filename, [datastreams[version]].flatten).datastream_files
      end
    end

    def datastream_files
      datastream_filenames if system(
        *UNZIP_CMD, @ds_zip_filename, *datastream_filenames
      )
    end

    private

    def datastream_filenames
      @datastreams.map do |datastream|
        "#{datastream_dir}/ssg-#{datastream}-ds.xml"
      end
    end

    def datastream_dir
      @ds_zip_filename.split('.')[0...-1].join('.')
    end
  end
end
