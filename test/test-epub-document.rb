# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase

  def assert_equal_contributors(expected, document)
    assert_equal(expected, document.extract_contributors)
  end

  def assert_equal_creators(expected, document)
    assert_equal(expected, document.extract_creators)
  end

  def assert_equal_title(expected, document)
    assert_equal(expected, document.extract_title)
  end

  def assert_equal_main_text(expected_file, document)
    expected_text = File.read(fixture_path(expected_file))
    assert_equal(expected_text, document.extract_main_text)
  end

  def assert_equal_xhtml_spine(expected, document)
    assert_equal(expected, document.extract_xhtml_spine)
  end

  def assert_equal_groonga_cmd_define_schema(document)
    define_schema_str = <<EOS
table_create Books TABLE_HASH_KEY ShortText
column_create Books author COLUMN_SCALAR ShortText
column_create Books main_text COLUMN_SCALAR LongText
column_create Books title COLUMN_SCALAR ShortText
EOS
    assert_equal(define_schema_str, document.create_groonga_cmd_define_schema)
  end

  class TestContributors < self
    def test_empty
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors([], @document)
    end

    def test_single
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_11_12.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors(["groongaコミュニティ"], @document)
    end

    def test_multiple
      # groonga_doc_11_12_multi_contributors.epub ... groonga_doc_11_12.epub に contributors を複数持たせたもの
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_11_12_multi_contributors.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors(["groongaコミュニティ A", "groongaコミュニティ B", "groongaコミュニティ C"], @document)
    end
  end

  class TestSpine < self
    def test_single
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
      document = EPUBSearcher::EPUBDocument.new(epub_book)

      assert_equal_xhtml_spine(["OEBPS/item0001.xhtml"], document)
      assert_equal_main_text("groonga_doc_all_main_text_expected.txt", document)
    end

    def test_multiple
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_11_12.epub'))
      document = EPUBSearcher::EPUBDocument.new(epub_book)

      assert_equal_main_text("groonga_doc_11_12_main_text_expected.txt", document)
      assert_equal_xhtml_spine(["item0001.xhtml", "item0002.xhtml"], document)
    end
  end

  class TestSingleSpine < self
    def setup
      # groonga_doc_all.epub ... spine を一つしか含まない EPUB ファイル
      #                          本文は groonga ドキュメント 1 章 が全て入っている
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
    end

    def test_extract_creators
      assert_equal_creators(["groonga"], @document)
    end

    def test_extract_title
      assert_equal_title("groongaについて", @document)
    end

    def test_create_groonga_cmd_define_schema
      assert_equal_groonga_cmd_define_schema(@document)
    end
  end

  class TestMultipleSpine < self
    def setup
      # groonga_doc_11_12.epub ... spine を二つ含む EPUB ファイル
      #                            本文は groonga ドキュメント 1.1 と 1.2 が入っている
      epub_book = EPUB::Parser.parse(fixture_path('groonga_doc_11_12.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
    end

    def test_extract_creators
      assert_equal_creators(["groongaプロジェクト"], @document)
    end

    def test_extract_title
      assert_equal_title("groongaについて", @document)
    end

    def test_create_groonga_cmd_define_schema
      assert_equal_groonga_cmd_define_schema(@document)
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end

end

