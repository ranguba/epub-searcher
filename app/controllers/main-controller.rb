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

  get :books do
    @books = books_from_groonga

    render 'books'
  end

  delete :books, :with => :id do
    result = delete_from_groonga(params[:id])
    halt 400, result.message unless result.success?
    redirect url_for(:books)
  end

end
