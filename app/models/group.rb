class Group < ApplicationRecord
  has_one_attached :group_image

  has_many :group_users, dependent: :destroy
  validates :name, presence: true, uniqueness: true


  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end

end
