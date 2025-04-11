class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms

  #アソシエーションが繋がっているテーブル名,実際のmodelの名前，外部キーとして何を持つかを表す(フォローした、されたの関係の記述)
  #class_nameでRelationshipテーブルを参照する
  #架空のテーブル名,中間テーブル名,実際にデータを取得しに行くテーブル名（2つのテーブルの繋がりを表したい）
  #一覧画面で使用するため、through:でスルーするテーブル、source:で参照するカラムを指定する

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships , class_name: "Relationship", foreign_key: "follower_id" ,dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分をフォローする（与フォロー）側の関係性
  has_many :relationships ,class_name: "Relationship", foreign_key: "followed_id" ,dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローした時の処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # フォローを外す時の処理
  def unfollow(user)
    relationships.find_by(follower_id: user_id).destroy
  end

  # フォローしているかを判定
  def following?(user)
    followings.include?(user)
  end

  # conentは検索ワード、methodは検索方法
  def self.search_for(content, method)
  # 検索方法によって処理を分岐(methodの値によって分岐)
  # perfect:完全一致（contentと完全一致するものを取得)
    if method == 'perfect'
  # Userモデルのnameカラムがcontentと完全一致するレコードを取得
  # whereメソッド→引数に条件を指定して、レコードを取得するメソッド
      User.where(name: content)
  # forward:前方一致（contentで指定された文字列で始まるものを取得)
    elsif method == 'forward'
  # Userモデルのnameカラムがcontentで始まるレコードを取得
  # LIKE演算子を使用して、部分一致検索を行う
  # LIKE演算子→SQLの構文で、文字列検索において特定のパターンに一致するかどうか判定する
  # nemeカラムの値がcontentで始まるレコードを取得
  # LIKE演算子の後に'%'を付けることで、contentで始まる任意の文字列を取得
      User.where('name LIKE ?', content + '%')
  # backward:後方一致（contentで指定された文字列で終わるものを取得)
    elsif method == 'backward'
  # Userモデルのnameカラムがcontentで終わるレコードを取得
      User.where('name LIKE ?', '%' + content)
  # どれにも当てはまらない場合（部分一致）
    else
  # Userモデルのnameカラムがcontentを含むレコードを取得
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

end
