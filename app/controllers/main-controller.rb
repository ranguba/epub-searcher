require 'groonga/client'

EPUBSearcher::App.controllers do

  layout :layout
  get :index do
    @query_words = params[:q]

    right_query = @query_words && !@query_words.empty?
    if right_query
      @results = search_from_groonga(@query_words)
    end

    render 'index'
  end

end
