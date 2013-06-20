# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase
  def setup
    # groonga_doc_all.epub ... spine を一つしか含まない EPUB ファイル
    #                          本文は groonga ドキュメント 1 章 が全て入っている
    epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
    @document = EPUBSearcher::EPUBDocument.new(epub_book)
  end

  def test_extract_contributors
    assert_equal([], @document.extract_contributors)
  end

  def test_extract_creators
    assert_equal(["groonga"], @document.extract_creators)
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

