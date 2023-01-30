class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  
  def self.looks(match, word)
    if match == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif match == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif match == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif match == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
  
  
  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
