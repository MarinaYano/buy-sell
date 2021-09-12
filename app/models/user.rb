class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :itemts, dependent: :destroy
 
  has_many :likes, dependent: :destroy
  has_many :liked_items, through: :likes, source: :item

  has_many :comments, dependent: :destroy

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :profile, length: { maximum: 200 } 

  mount_uploader :image, ImageUploader

  def already_liked?(item)
    self.likes.exists?(item_id: item.id)
  end
end
