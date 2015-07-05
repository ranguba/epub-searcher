require 'test-unit'

require 'epub/book'
require 'epub/parser'
require 'epub-searcher/database'
require 'epub-searcher/epub-document'

class TestDatabase < Test::Unit::TestCase
  def setup
    @database = EPUBSearcher::Database.new
    @database.db_path = db_path
    remove_db_directory
  end

  def teardown
    super
    remove_db_directory
  end

  def remove_db_directory
    FileUtils.rm_rf(File.dirname(@database.db_path))
  end

  class TestSetup < self
    def test_setup_database
      @database.setup_database

      dump_command = "groonga #{@database.db_path} dump"
      dumped_text = `#{dump_command}`

      expected = File.read(fixture_path('defined_schema_dump_expected.txt'))
      assert_equal(normalize_newline(expected),
                   normalize_newline(dumped_text))
    end
  end

  class TestLoadRecords < self
    def setup
      super
      @database.setup_database
    end

    def test_load_epub_documents
      documents = Array.new
      documents << EPUBSearcher::EPUBDocument.open(fixture_path('empty_contributors_single_spine.epub'))
      documents << EPUBSearcher::EPUBDocument.open(fixture_path('single_contributors_multi_spine.epub'))
      documents << EPUBSearcher::EPUBDocument.open(fixture_path('multi_contributors_multi_spine.epub'))
      @database.load_records(documents)

      dump_command = "groonga #{@database.db_path} dump"
      dumped_text = `#{dump_command}`.gsub(%r|/.+?/test/epub-searcher/fixtures/|) do
        "${PREFIX}/test/epub-searcher/fixtures/"
      end

      expected = File.read(fixture_path('loaded_records_dump_expected.txt'))
      assert_equal(normalize_newline_literal(expected),
                   normalize_newline_literal(dumped_text))
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end

  def db_path
    File.join(__dir__, 'tmp', 'db', 'epub-searcher.db')
  end
end
