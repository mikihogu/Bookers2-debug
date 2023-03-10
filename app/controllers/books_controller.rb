class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @users = User.all
    @book_comment = BookComment.new
    #閲覧者数
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.month).at_beginning_of_day
    books = Book.includes(:favorited_users)
      .sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @books = Kaminari.paginate_array(books).page(params[:page])
    if params[:latest]
      @books = Book.latest.page(params[:page])
    elsif params[:old]
      @books = Book.old.page(params[:page])
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end



end
