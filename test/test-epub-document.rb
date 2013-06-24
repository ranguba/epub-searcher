# -*- coding: utf-8 -*-

require 'fileutils'

require 'test-unit'
require 'mocha/setup'

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

  class TestContributors < self
    def test_empty
      epub_book = EPUB::Parser.parse(fixture_path('empty_contributors_single_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors([], @document)
    end

    def test_single
      epub_book = EPUB::Parser.parse(fixture_path('single_contributors_multi_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors(['groongaコミュニティ'], @document)
    end

    def test_multiple
      epub_book = EPUB::Parser.parse(fixture_path('multi_contributors_multi_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal_contributors(['groongaコミュニティ A', 'groongaコミュニティ B', 'groongaコミュニティ C'], @document)
    end
  end

  class TestSpine < self
    def test_single
      epub_book = EPUB::Parser.parse(fixture_path('empty_contributors_single_spine.epub'))
      document = EPUBSearcher::EPUBDocument.new(epub_book)

      assert_equal_xhtml_spine(['OEBPS/item0001.xhtml'], document)
      assert_equal_main_text('empty_contributors_single_spine_main_text_expected.txt', document)
    end

    def test_multiple
      epub_book = EPUB::Parser.parse(fixture_path('single_contributors_multi_spine.epub'))
      document = EPUBSearcher::EPUBDocument.new(epub_book)

      assert_equal_main_text('single_contributors_multi_spine_main_text_expected.txt', document)
      assert_equal_xhtml_spine(['item0001.xhtml', 'item0002.xhtml'], document)
    end
  end

  class TestExtracts < self
    def setup
      epub_book = EPUB::Parser.parse(fixture_path('empty_contributors_single_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
    end

    def test_creators
      assert_equal_creators(['groonga'], @document)
    end

    def test_title
      assert_equal_title('groongaについて', @document)
    end
  end

  class TestGroonga < self
    def setup
      epub_book = EPUB::Parser.parse(fixture_path('empty_contributors_single_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      @document.db_path = File.join(__dir__, 'tmp', 'db', 'epub-searcher.db')
      remove_db_directory
    end

    def teardown
      remove_db_directory
    end

    def remove_db_directory
      FileUtils.rm_rf(File.dirname(@document.db_path))
    end

    def test_define_schema
      @document.define_schema

      dump_command = "groonga #{@document.db_path} dump"
      dumped_text = `#{dump_command}`

      expected = File.read(fixture_path('defined_schema_dump_expected.txt'))
      assert_equal(expected, dumped_text)
    end
  end

  class TestConstructor < self
    def test_epub_book_object
      epub_book = EPUB::Parser.parse(fixture_path('empty_contributors_single_spine.epub'))
      @document = EPUBSearcher::EPUBDocument.new(epub_book)
      assert_equal(EPUB::Book, @document.epub_book.class)
    end

    def test_local_path
      epub_path = fixture_path('empty_contributors_single_spine.epub')
      @document = EPUBSearcher::EPUBDocument.new(epub_path)
      assert_equal(EPUB::Book, @document.epub_book.class)
    end
  end

  class TestRemoteFile < self
    def setup
      epub_path = fixture_path('empty_contributors_single_spine.epub')
      File.expects(:readable_real?).with(epub_path).returns(false)
      @document = EPUBSearcher::EPUBDocument.new(epub_path)
    end

    def test_remote_file
      assert_equal(EPUB::Book, @document.epub_book.class)
      assert_equal_main_text('empty_contributors_single_spine_main_text_expected.txt', @document)
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end

end

