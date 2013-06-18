module EPUBSearcher
  class EPUBDocument
    def extract_title(epub_book)
      metadata = epub_book.metadata
      return metadata.title
    end
  end
end

