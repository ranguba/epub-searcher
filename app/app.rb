module EPUBSearcher
  class App < Padrino::Application
    register ScssInitializer
    register Padrino::Rendering
    register Padrino::Helpers

    enable :sessions

    ##
    # Caching support
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
    # set :cache, Padrino::Cache::Store::Memory.new(50)
    # set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 505 do
    #     render 'errors/505'
    #   end
    #

    def search_from_groonga(query_words)
      begin
        db.select(
          :table => :Books,
          :query => query_words,
          :match_columns => 'author,title,main_text',
          :output_columns => 'author,title,snippet_html(main_text)',
          :limit => -1,
          :drilldown => 'author',
          :drilldown_output_columns => '_key,_nsubrecs',
          :drilldown_limit => -1
        )
      ensure
        db.close
      end
    end

    def books_from_groonga
      begin
        db.select(
          :table => :Books,
          :output_columns => '_id,author,title,file_path',
          :limit => -1,
          :drilldown => 'author',
          :drilldown_output_columns => '_key,_nsubrecs',
          :drilldown_limit => -1
        )
      ensure
        db.close
      end
    end

    def author_drilldowns_from_groonga
      begin
        db.select(
          :table => :Books,
          :drilldown => 'author',
          :drilldown_output_columns => '_key,_nsubrecs',
          :drilldown_limit => -1
        )
      ensure
        db.close
      end
    end

    def delete_from_groonga(id)
      begin
        params = {
          :table => :Books,
          :id => id
        }
        db.delete(params)
      ensure
        db.close
      end
    end

    private
    def db
      @db ||= RemoteDatabase.new(default_db_options)
    end

    def default_db_options
      {
        :protocol => :http,
        :host => settings.droonga_host,
        :port => settings.droonga_port
      }
    end
  end

end
