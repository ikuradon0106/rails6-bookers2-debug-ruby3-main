class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    #検索ワードからの情報を受け取る
    @word = params[:word]
    # 検索モデル（userかbook）からの情報を受け取る
    @model = params[:model]

    # if分を使って検索モデルUserかbookで条件分岐させる
    if @model ==  "User"
    # 検索方法(search)と検索ワード(word)を参照→データを検索
    # インスタンス変数(@user)にUserモデル内での検索結果を代入
      @users = User.looks(params[:search], params[:word])
    else
    # インスタンス変数(@book)にBookrモデル内での検索結果を代入
      @books = Book.looks(params[:search], params[:word])
    end
  end

end
