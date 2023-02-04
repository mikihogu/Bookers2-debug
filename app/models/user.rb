class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  # いいね機能
  has_many :favorites, dependent: :destroy
  # コメント機能
  has_many :book_comments, dependent: :destroy
  # フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # DM機能
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_one_attached :profile_image

  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  # 検索機能
  def self.search_for(content, method)
    if method == "perfect_match"
      User.where(name: content)
    elsif method == "forward_match"
      User.where('name LIKE?', content + '%')
    elsif method == "backward_match"
      User.where('name LIKE?','%' + content)
    else
      User.where('name LIKE?','%' + content + '%')
    end
  end



  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
