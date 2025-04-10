class Book < ApplicationRecord
  belongs_to :user

  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # Bookモデルに対してweek_favoritesメソッドという関連付けを追加（1週間いないのいいねを取得）
  # has_many→Bookモデルとfavoriteモデルを1対多の関係にする（Bookモデルが親、favoriteモデルが子、week_favoritesは中間モデルの名前）
  #　-> { 条件 }→データを絞り込むための「条件」を記載（無名関数=ラムダを表す構文、名前を付けすにその場で使える関数を定義している）。
  # where()→関連するためのデータを絞り込むための条件、ex)Where(青)とすると青の部分が条件に該当するデータを取得できる。
  # created_at:~→カラムが指定した期間に該当するデータのみを取得(そのカラムを使って、特定の日時の範囲を指定する)
  
  # Time.current.at_end_of_day→現在の時間を取得するメソッド
  # - 6.days→現在の時間から6日前の時間を取得するメソッド
  # .at_beginning_of_day→その日の最初の時間を取得するメソッド
  # つまり「6日前の00:00:00から現在の23:59:59までの範囲」を取得している
  
  # class_nameの指定で、実際のモデル名を指定（このままだとweek_favorites(存在しないモデル名)を参照してしまう
  has_many :week_favorites, -> { where(created_at:((Time.current.at_end_of_day - 6.days).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'

  has_one_attached :image

  # バリデーション
  validates :image, presence:true

  validates :title, presence:true
  validates :body, presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # コードの内容はuser.rbに記述したものと同じ
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(tiltle: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + content)
    else
      Book.where('title LIKE ?', '%' + content + '%')
    end
  end
end
