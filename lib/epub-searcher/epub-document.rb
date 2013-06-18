module EPUBSearcher
  class EPUBDocument
    def initialize(epub_book)
      @epub_book = epub_book
    end

    def extract_author
      metadata = @epub_book.metadata
      return metadata.author
    end

    def extract_title
      metadata = @epub_book.metadata
      return metadata.title
    end
  end
end

