# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase
  def setup
    # groonga_doc_all.epub ... spine を一つしか含まない EPUB ファイル
    #                          本文は groonga ドキュメント 1 章 が全て入っている
    epub_book_1 = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
    @document_1 = EPUBSearcher::EPUBDocument.new(epub_book_1)

    # groonga_doc_11_12.epub ... spine を二つ含む EPUB ファイル
    #                            本文は groonga ドキュメント 1.1 と 1.2 が入っている
    epub_book_2 = EPUB::Parser.parse(fixture_path('groonga_doc_11_12.epub'))
    @document_2 = EPUBSearcher::EPUBDocument.new(epub_book_2)
  end

  def test_extract_contributors
    assert_equal([], @document_1.extract_contributors)
    assert_equal(["groongaコミュニティ A", "groongaコミュニティ B", "groongaコミュニティ C"], @document_2.extract_contributors)
  end

  def test_extract_creators
    assert_equal(["groonga"], @document_1.extract_creators)
    assert_equal(["groongaプロジェクト"], @document_2.extract_creators)
  end

  def test_extract_title
    assert_equal("groongaについて", @document_1.extract_title)
    assert_equal("groongaについて", @document_2.extract_title)
  end

  def test_extract_xhtml_spine
    assert_equal(["OEBPS/item0001.xhtml"], @document_1.extract_xhtml_spine)
    assert_equal(["item0001.xhtml", "item0002.xhtml"], @document_2.extract_xhtml_spine)
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end
end

