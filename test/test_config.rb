$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require "test/unit"

class Test::Unit::TestCase
  include Rack::Test::Methods

  # You can use this method to custom specify a Rack app
  # you want rack-test to invoke:
  #
  #   app Epub::App
  #   app Epub::App.tap { |a| }
  #   app(Epub::App) do
  #     set :foo, :bar
  #   end
  #
  def app(app = nil &blk)
    @app ||= block_given? ? app.instance_eval(&blk) : app
    @app ||= Padrino.application
  end

  def normalize_newline(text)
    text.gsub(/(?:\r\n)+/, "\r\n")
  end

  def normalize_newline_literal(text)
    text.gsub(/(?:\\r\\n)+/, "\\r\\n")
  end
end
