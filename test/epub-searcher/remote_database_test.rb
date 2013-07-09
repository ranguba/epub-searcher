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
        {:name=>:Terms, :flags=>'TABLE_PAT_KEY', :key_type=>:ShortText, :default_tokenizer=>:TokenBigram, :normalizer=>:NormalizerAuto},
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

      expected_table_create_params.each do |params|
        @database.client.expects(:table_create).with(params)
      end

      expected_column_create_params.each do |params|
        @database.client.expects(:column_create).with(params)
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

      documents = epub_paths.map do |path|
        document = EPUBSearcher::EPUBDocument.open(fixture_path(path))
        document
      end

      expected_values = File.read(fixture_path('load_records_params_values_expected.txt'))
      expected = {
        :table => :Books,
        :values => expected_values,
      }
      @database.client.expects(:load).with do |actual_params|
        actual_params[:values].gsub!(%r|"file_path":"/.+?/test/epub-searcher/fixtures/|) do
          "\"file_path\":\"${PREFIX}/test/epub-searcher/fixtures/"
        end
        expected == actual_params
      end

      @database.load_records(documents)
    end
  end

  private
  def fixture_path(basename)
    File.join(__dir__, 'fixtures', basename)
  end
end
