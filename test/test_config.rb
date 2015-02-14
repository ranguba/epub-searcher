RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require "test/unit"

Capybara.app = Padrino.application

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Capybara::DSL

  # You can use this method to custom specify a Rack app
  # you want rack-test to invoke:
  #
  #   app EPUBSearcher::App
  #   app EPUBSearcher::App.tap { |a| }
  #   app(EPUBSearcher::App) do
  #     set :foo, :bar
  #   end
  #
  def app(app = nil, &blk)
    @app ||= block_given? ? app.instance_eval(&blk) : app
    @app ||= Padrino.application
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def normalize_newline(text)
    text.gsub(/(?:\r\n)+/, "\r\n").chomp + "\n"
  end

  def normalize_newline_literal(text)
    text.gsub(/(?:\\r\\n)+/, "\\r\\n").chomp + "\n"
  end

  def omit_on_travis
    omit 'Background Droonga processes not running on Travis CI' if ENV['TRAVIS']
  end
end
