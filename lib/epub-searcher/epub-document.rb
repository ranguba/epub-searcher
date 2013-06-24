require 'open-uri'
require 'net/http'

require 'epub/parser'
require 'epub-searcher/remote-parser'

module EPUBSearcher
  class EPUBDocument
    attr_reader :epub_book

    def initialize(epub_book)
      case epub_book
      when EPUB::Book
        @epub_book = epub_book
      when String
        begin
          @epub_book = EPUB::Parser.parse(epub_book)
        rescue RuntimeError
          local_path = get_remote_epub_file(epub_book)
          @epub_book = EPUB::Parser.parse(local_path)
        end
      end
    end

    def extract_contributors
      metadata = @epub_book.metadata
      return metadata.contributors.map(&:content)
    end

    def extract_creators
      metadata = @epub_book.metadata
      return metadata.creators.map(&:content)
    end

    def extract_title
      metadata = @epub_book.metadata
      return metadata.title
    end

    def extract_main_text
      main_text = ''
      @epub_book.each_page_on_spine do |item|
        content = Nokogiri::HTML(item.read)
        main_text << content.at('body').text
      end
      return main_text
    end

    def extract_xhtml_spine
      xhtml_spine = Array.new
      @epub_book.each_page_on_spine do |item|
        if item.media_type == 'application/xhtml+xml'
          basename = item.href
          xhtml_spine << basename.to_s
        end
      end
      return xhtml_spine
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
      File.join(__dir__, '..', '..', 'tmp', basename)
    end

    def download_remote_file(url)
      Net::HTTP.get_response(URI.parse(url)).body
    end
  end
end

