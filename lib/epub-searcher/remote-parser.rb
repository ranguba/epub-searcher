require 'open-uri'

module EPUBSearcher
  class RemoteParser < EPUB::Parser
    def initialize(filepath, options = {})
      begin
        super(filepath, options)
      rescue RuntimeError
        @filepath = open(filepath).path
        @book = create_book options
        @book.epub_file = @filepath
      end
    end
  end
end

