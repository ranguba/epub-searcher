module EPUBSearcher
  class EPUBDocument
    def initialize(epub_book)
      @epub_book = epub_book
    end

    def extract_contributors
      metadata = @epub_book.metadata
      return metadata.contributors.map {|contributor| contributor.content}
    end

    def extract_creators
      metadata = @epub_book.metadata
      return metadata.creators.map {|creator| creator.content}
    end

    def extract_title
      metadata = @epub_book.metadata
      return metadata.title
    end

    def extract_xhtml_spine
      xhtml_spine = Array.new
      @epub_book.each_page_on_spine do |item|
        if item.media_type == "application/xhtml+xml"
          basename = item.href
          xhtml_spine << basename.to_s
        end
      end
      return xhtml_spine
    end
  end
end

