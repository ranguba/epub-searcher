require 'open-uri'
require 'net/http'

module EPUBSearcher
  class EPUBFile
    class << self
    def temporary_local_dir=(dir)
      @@temporary_local_dir = dir
    end
    end

    attr_reader :local_path

    def initialize(uri)
      scheme = URI(uri).scheme
      if !scheme || scheme == 'file'
        @local_path = uri
      else
        @local_path = get_remote_epub_file(uri)
      end
    end

    def temporary_local_dir
      @@temporary_local_dir ||= File.join(__dir__, '..', '..', 'tmp')
    end

    private
    def get_remote_epub_file(url)
      basename = File.basename(url)
      local_path = make_temporary_local_path(basename)
      FileUtils.mkdir_p(File.dirname(local_path))
      open(local_path, 'w') do |file|
        file.puts download_remote_file(url)
      end
      return local_path
    end

    def make_temporary_local_path(basename)
      File.join(temporary_local_dir, basename)
    end

    def download_remote_file(url)
      Net::HTTP.get_response(URI.parse(url)).body
    end
  end
end

