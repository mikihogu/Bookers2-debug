class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @word = params[:word]
    @model = params[:model]
    @match = params[:match]

    if @model == "user"
      @records = User.search_for(@word, @match)
    else #@model == "book"
      @records = Book.search_for(@word, @match)
    end
  end

end
