require 'groonga/client'

Epub::App.controllers do

  layout :layout
  get :index do
    query_words = params[:q]

    client = Groonga::Client.open
    select = client.select(
      :table => :Books,
      :query => query_words,
      :match_columns => 'author,title,main_text',
      :output_columns => 'author,title,snippet_html(main_text)',
      :command_version => 2,
    )

    @results = Array.new
    select.records.each do |record|
      @results << record
    end
    render 'index'
  end

end