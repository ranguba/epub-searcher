# -*- coding: utf-8 -*-

require 'test-unit'

require 'epub/parser'
require 'epub-searcher/epub-document'

class TestEPUBDocument < Test::Unit::TestCase

  class TestSingleSpine < self
    def setup
      # groonga_doc_all.epub ... spine を一つしか含まない EPUB ファイル
      #                          本文は groonga ドキュメント 1 章 が全て入っている
      epub_book_1 = EPUB::Parser.parse(fixture_path('groonga_doc_all.epub'))
      @document_1 = EPUBSearcher::EPUBDocument.new(epub_book_1)
    end

    def test_extract_contributors
      assert_equal([], @document_1.extract_contributors)
    end

    def test_extract_creators
      assert_equal(["groonga"], @document_1.extract_creators)
    end

    def test_extract_title
      assert_equal("groongaについて", @document_1.extract_title)
    end

    def test_main_text
      doc_all_expected_text = File.read(fixture_path("groonga_doc_all_main_text_expected.txt"))
      assert_equal(doc_all_expected_text, @document_1.extract_main_text)
    end

    def test_extract_xhtml_spine
      assert_equal(["OEBPS/item0001.xhtml"], @document_1.extract_xhtml_spine)
    end

    def test_create_groonga_cmd_define_schema
      define_schema_str = <<EOS
table_create Books TABLE_HASH_KEY ShortText
column_create Books author COLUMN_SCALAR ShortText
column_create Books main_text COLUMN_SCALAR LongText
column_create Books title COLUMN_SCALAR ShortText
EOS
      assert_equal(define_schema_str, @document_1.create_groonga_cmd_define_schema)
    end
  end

  class TestMultipleSpine < self
    def setup
      # groonga_doc_11_12.epub ... spine を二つ含む EPUB ファイル
      #                            本文は groonga ドキュメント 1.1 と 1.2 が入っている
      epub_book_2 = EPUB::Parser.parse(fixture_path('groonga_doc_11_12.epub'))
      @document_2 = EPUBSearcher::EPUBDocument.new(epub_book_2)
    end

    def test_extract_contributors
      assert_equal(["groongaコミュニティ A", "groongaコミュニティ B", "groongaコミュニティ C"], @document_2.extract_contributors)
    end

    def test_extract_creators
      assert_equal(["groongaプロジェクト"], @document_2.extract_creators)
    end

    def test_extract_title
      assert_equal("groongaについて", @document_2.extract_title)
    end

    def test_main_text
      doc_11_12_expected_text = File.read(fixture_path("groonga_doc_11_12_main_text_expected.txt"))
      assert_equal(doc_11_12_expected_text, @document_2.extract_main_text)
    end

    def test_extract_xhtml_spine
      assert_equal(["item0001.xhtml", "item0002.xhtml"], @document_2.extract_xhtml_spine)
    end

    def test_create_groonga_cmd_define_schema
      define_schema_str = <<EOS
table_create Books TABLE_HASH_KEY ShortText
column_create Books author COLUMN_SCALAR ShortText
column_create Books main_text COLUMN_SCALAR LongText
column_create Books title COLUMN_SCALAR ShortText
EOS
      assert_equal(define_schema_str, @document_2.create_groonga_cmd_define_schema)
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end

end

