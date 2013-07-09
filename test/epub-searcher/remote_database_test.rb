require 'epub-searcher/remote-database'

class TestRemoteDatabase < Test::Unit::TestCase
  class TestSetup < self
    def setup
      @database = EPUBSearcher::RemoteDatabase.new(:protocol => :http)
    end

    def teardown
      @database.close
    end

    def test_setup_database
      expected_table_create_params = [
        {:name=>:Books, :flags=>'TABLE_NO_KEY'},
        {:name=>:Terms, :flags=>'TABLE_PAT_KEY', :type=>:ShortText, :default_tokenizer=>:TokenBigram, :normalizer=>:NormalizerAuto},
      ]

      expected_column_create_params = [
        {:table=>:Books, :name=>'author', :flags=>'COLUMN_SCALAR', :type=>:ShortText},
        {:table=>:Books, :name=>'file_path', :flags=>'COLUMN_SCALAR', :type=>:ShortText},
        {:table=>:Books, :name=>'title', :flags=>'COLUMN_SCALAR', :type=>:ShortText},
        {:table=>:Books, :name=>'main_text', :flags=>'COLUMN_SCALAR', :type=>:LongText},
        {:table=>:Terms, :name=>'entries_author_index', :flags=>'COLUMN_INDEX|WITH_POSITION', :type=>:Books, :source=>'author'},
        {:table=>:Terms, :name=>'entries_main_text_index', :flags=>'COLUMN_INDEX|WITH_POSITION', :type=>:Books, :source=>'main_text'},
        {:table=>:Terms, :name=>'entries_title_index', :flags=>'COLUMN_INDEX|WITH_POSITION', :type=>:Books, :source=>'title'},
      ]

      @database.client
        .expects(:table_create)
        .times(expected_table_create_params.size)
        .with do |params|
        expected_table_create_params.include?(params)
      end

      @database.client
        .expects(:column_create)
        .times(expected_column_create_params.size)
        .with do |params|
        expected_column_create_params.include?(params)
      end

      @database.setup_database
    end
  end

  class TestRecords < self
    def setup
      @database = EPUBSearcher::RemoteDatabase.new(:protocol => :http)
    end

    def teardown
      @database.close
    end

    def test_load_records
      epub_paths = [
        'empty_contributors_single_spine.epub',
        'single_contributors_multi_spine.epub',
        'multi_contributors_multi_spine.epub',
      ]

      documents = epub_paths.collect do |path|
        document = EPUBSearcher::EPUBDocument.open(fixture_path(path))
        document
      end

      expected = File.read(fixture_path('load_records_params_expected.txt'))
      @database.client
        .expects(:load)
        .once
        .with do |params|
        expected == params.to_s
      end

      @database.load_records(documents)
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end
end
