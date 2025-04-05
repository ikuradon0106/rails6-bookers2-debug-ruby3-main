class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    # if分を使って検索モデルUserかbookで条件分岐させる
    if @model ==  "User"
    # 検索方法(search)と検索ワード(word)を参照→データを検索
    # インスタンス変数(@user)にUserモデル内での検索結果を代入
      @records = User.search_for(@search, @method)
    else
    # インスタンス変数(@book)にBookモデル内での検索結果を代入
      @records = Book.search_for(@search, @method)
    end
  end

end
