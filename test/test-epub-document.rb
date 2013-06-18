# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase
  def text_extract_author
    epub_book = EPUB::Parser.parse(fixture_path('groonga.epub'))
    document = EPUBSearcher::EPUBDocument.new(epub_book)
    assert_equal("groonga", document.extract_author)
  end

  def test_extract_title
    epub_book = EPUB::Parser.parse(fixture_path('groonga.epub'))
    document = EPUBSearcher::EPUBDocument.new(epub_book)
    assert_equal("groongaについて", document.extract_title)
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end
end

