class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  
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
