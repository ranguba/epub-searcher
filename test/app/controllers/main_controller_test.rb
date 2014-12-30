# -*- coding: utf-8 -*-
class MainControllerTest < Test::Unit::TestCase
  class << self
    def startup
      @@test_documents ||= %w[kk1.epub kk2.epub css21.epub].map {|filename|
        path = Padrino.root("data/test-setup/#{filename}")
        EPUBSearcher::EPUBDocument.open(path)
      }
    end
  end

  def test_get_index
    get '/'

    assert last_response.ok?
  end

  def test_get_index_form
    visit '/'

    assert page.has_selector?('form input[type="search"]')
  end

  def test_get_index_query
    omit_on_travis

    get '/?q=test'

    assert last_response.ok?
  end

  def test_get_index_query_form
    omit_on_travis

    visit "/?q=%3C"

    assert_equal '<', find('form input[type="search"]').value
  end

  def test_get_books
    omit_on_travis

    truncate_books
    load_test_data

    visit '/books'

    [
      'ケヴィン・ケリー著作選集　１',
      'ケヴィン・ケリー著作選集　２',
      'CSS2.1仕様 日本語訳 EPUB版'
    ].each do |title|
      assert page.has_content?(title)
    end
  end

  def db
    @db ||= EPUBSearcher::RemoteDatabase.new(db_options)
  end

  def db_options
    {
      host: EPUBSearcher::App.settings.droonga_host,
      port: EPUBSearcher::App.settings.droonga_port,
    }
  end

  def truncate_books
    books = db.select(
      table: :Books,
      output_columns: '_id'
    )
    books.each do |book|
      params = {
        table: :Books,
        id: book['_id']
      }
      db.delete params
    end
  end

  def load_test_data
    db.load_records @@test_documents
  end
end
