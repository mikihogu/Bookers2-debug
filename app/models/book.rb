class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  # 閲覧数
  has_many :view_counts, dependent: :destroy


  def self.search_for(content, method)
    if method == "perfect_match"
      Book.where(title: content)
    elsif method == "forward_match"
      Book.where('title LIKE?', content + '%')
    elsif method == "backward_match"
      Book.where('title LIKE?','%' + content)
    else
      Book.where('title LIKE?','%' + content + '%')
    end
  end


  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}

end
