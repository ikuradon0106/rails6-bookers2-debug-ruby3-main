class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new


  end

  def index
    # 設定しているタイムゾーンを基に現在日時を取得
    to = Time.current.at_end_of_day
    # 取得した現在日時から6日前の日時を計算
    from = (to - 6.days).at_beginning_of_day
    # 上記を2行を説明すると、一週間分のデータを取ってきたよ
    
    # いいねの数をもとにBookを並び替えたい
    # Bookモデルからすべてのbookレコードを取得し、@booksインスタンス変数に格納

    # .sortメソッド（配列（またはリスト）の中身を順番に並び替えるメソッド）を使って、取得したBookを並び替え
    # {}の中で何を基準に並び変えるかを設定、この場合favorite(いいね)の数で並べる
    # aとbはそれぞれ比較対象のbookを表す変数（a は配列の最初の本、b はその次の本。aとbの違いを比較して、順番を決める。）
    #.where→条件に合ったデータだけを取得する」
    # created_at: from...to は「作成日時が from から to の間にあるものだけ」を取得する条件
    # .size→取得したデータの件数（今回はいいねの数）を取得するメソッド

    # <=>はRubyの比較演算子で、左側の値が小さい場合は-1、大きい場合は1、等しい場合は0を返す
    # つまり、aとbのfavoriteの数を比較して、aがbよりも少ない場合は-1を返し、aがbよりも多い場合は1を返す
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=> 
      a.favorites.where(created_at: from...to).size
      }

    @book = Book.new 
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
