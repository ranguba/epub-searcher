require 'time'
require 'epub/parser'
require 'epub-searcher/epub-file'

module EPUBSearcher
  class EPUBDocument
    class << self
      def open(uri)
        epub_file = EPUBFile.new(uri)
        epub_book = EPUB::Parser.parse(epub_file.local_path)
        new(epub_book)
      end
    end

    attr_reader :epub_book

    def initialize(epub_book)
      @epub_book = epub_book
    end

    def extract_unique_identifier
      @epub_book.unique_identifier.content
    end

    def extract_modified
      modified_string = @epub_book.modified.content
      Time.parse(modified_string).to_f
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
        content = item.content_document.nokogiri
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

    def file_path
      @epub_book.epub_file
    end
  end
end

