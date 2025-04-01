class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  #アソシエーションが繋がっているテーブル名,実際のmodelの名前，外部キーとして何を持つかを表す(フォローした、されたの関係の記述)
  has_many :relationships , class_name: "Relationship", foreign_key: "follower_id" ,dependent: :destroy
  has_many :relationships ,class_name: "Relationship", foreign_key: "followed_id" ,dependent: :destroy

  #架空のテーブル名,中間テーブル名,実際にデータを取得しに行くテーブル名（2つのテーブルの繋がりを表したい）
  has_many :user_follower, through: :relationships, source: :users
  has_many :user_followed, through: :relationships, source: :users

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
