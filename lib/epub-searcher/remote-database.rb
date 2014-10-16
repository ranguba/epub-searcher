require 'groonga/client'

module EPUBSearcher
  class RemoteDatabase
    attr_reader :client

    def initialize(options={})
      default_options = {
        :protocol => :http
      }
      @client = Groonga::Client.open(default_options.merge(options))
    end

    def close
      @client.close
    end

    def load_records(epub_documents)
      groonga_load_records(epub_documents)
    end

    def setup_database
      groonga_setup_db_books
      groonga_setup_db_terms
    end

    private
    def groonga_setup_db_books
      @client.table_create(:name => :Books, :flags => 'TABLE_NO_KEY')
      ['author', 'file_path', 'title'].each do |column|
        @client.column_create(
          :table => :Books,
          :name => column,
          :flags => 'COLUMN_SCALAR',
          :type => :ShortText,
        )
      end
      @client.column_create(
        :table => :Books,
        :name => 'main_text',
        :flags => 'COLUMN_SCALAR',
        :type => :LongText,
      )
    end

    def groonga_setup_db_terms
      @client.table_create(
        :name => :Terms,
        :flags => 'TABLE_PAT_KEY',
        :key_type => :ShortText,
        :default_tokenizer => :TokenBigram,
        :normalizer => :NormalizerAuto,
      )
      ['author', 'main_text', 'title'].each do |column|
        @client.column_create(
          :table => :Terms,
          :name => 'entries_' + column + '_index',
          :flags => 'COLUMN_INDEX|WITH_POSITION',
          :type => :Books,
          :source => column,
        )
      end
    end

    def groonga_load_records(epub_documents)
      records = epub_documents.map do |epub_document|
        {
          :author => epub_document.extract_creators.join(' '),
          :main_text => epub_document.extract_main_text,
          :title => epub_document.extract_title,
          :file_path => epub_document.file_path,
        }
      end
      @client.load(:table => :Books, :values => records.to_json)
    end
  end
end
