EPUBSearcher::App.controllers do

  layout :layout
  get :index do
    @query_words = params[:q]

    right_query = @query_words && !@query_words.empty?
    if right_query
      results = search_from_groonga(@query_words)
      @results = results.records
      @drilldowns = results.drilldowns
    else
      @drilldowns = author_drilldowns_from_groonga.drilldowns
    end

    render 'index'
  end

  get :books do
    results = books_from_groonga
    @books = results.records
    @drilldowns = results.drilldowns

    render 'books'
  end

  delete :books, :with => :id do
    result = delete_from_groonga(params[:id])
    halt 400, result.message unless result.success?
    redirect url_for(:books)
  end

end
