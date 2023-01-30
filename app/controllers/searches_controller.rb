class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @subject = params[:subject]
    @word = params[:word]

    if @subject == "User"
      @users = User.looks(params[:match], params[:word])
    else
      @books = Book.looks(params[:match], params[:word])
    end
  end

end
