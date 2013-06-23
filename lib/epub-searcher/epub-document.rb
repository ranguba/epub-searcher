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
        @epub_book = EPUBSearcher::RemoteParser.parse(epub_book)
      end
    end

    def create_groonga_command_define_schema
      <<EOS
table_create Books TABLE_HASH_KEY ShortText
column_create Books author COLUMN_SCALAR ShortText
column_create Books main_text COLUMN_SCALAR LongText
column_create Books title COLUMN_SCALAR ShortText
EOS
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
  end
end

