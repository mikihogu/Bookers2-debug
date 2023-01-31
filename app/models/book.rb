class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy


  def self.search_for(word, match)
    if match == "perfect_match"
      Book.where(title: word)
    elsif match == "forward_match"
      Book.where('title LIKE?', word+'%')
    elsif match == "backward_match"
      Book.where('title LIKE?','%'+word)
    else
      Book.where('title LIKE?','%'+word+'%')
    end
  end



  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
