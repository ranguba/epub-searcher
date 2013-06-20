# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase
  def setup
    epub_book = EPUB::Parser.parse(fixture_path('groonga.epub'))
    @document = EPUBSearcher::EPUBDocument.new(epub_book)
  end

  def test_extract_author
    assert_equal(["groonga"], @document.extract_author)
  end

  def test_extract_title
    assert_equal("groongaについて", @document.extract_title)
  end

  def test_extract_xhtml_spine
    assert_equal(["OEBPS/item0001.xhtml"], @document.extract_xhtml_spine)
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end
end

