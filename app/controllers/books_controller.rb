class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new


  end

  def index
    # BookモデルからすべてのBookレコードを取得
    @books = Book.all
    @book = Book.new

        # 設定しているタイムゾーンを基に現在日時を取得
        to = Time.current.at_end_of_day
        # 取得した現在日時から6日前の日時を計算
        from = (to - 6.days).at_beginning_of_day
        # 上記を2行を説明すると、一週間分のデータを取ってきたよ
    
        # いいねの数をもとにBookを並び替えたい
        # Bookモデルからすべてのレコードを取得し、関連するFavoriteレコードも同時に読み込む（N+1対策）
        # 取得したBookを、各Bookに紐づくFavoriteの数で並び替える
        # sort_byメソッド内で、favorites.where(created_at: from...to) を使って、指定した期間（from〜to）の間に作成されたFavoriteの数を取得
        # sizeメソッドでその数を取得し、それを基準に並び替え
        # 最後にreverseで降順（いいね数が多い順）にする
        @books = Book.includes(:favorites).sort_by {|x|
        x.favorites.where(created_at: from...to).size
      }.reverse

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user = current_user
      redirect_to books_path
    end
  end 

end
