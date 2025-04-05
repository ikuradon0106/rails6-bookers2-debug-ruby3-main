class SearchesController < ApplicationController
  # ログインしているユーザーのみがアクセスできるようにする
  before_action :authenticate_user!
  
  def search
    # ユーザーが選択した検索モデル（userかbook)を変数に代入
    @model = params[:model]
    # ユーザーが入力した検索ワードを変数に代入
    @content = params[:content]
    # ユーザーが選択した4つの検索方法を変数に代入
    @method = params[:method]

    # if文を使用して、ユーザーが選択した検索モデル（userかbook)によって処理を分岐
    # @modelが"User"の場合は、Userモデルを検索
    if @model ==  "User"
    # 選択された検索対象（Userモデル）に対して、search_forメソッドを使用して検索を実行し、結果を変数に代入
      @records = User.search_for(@content, @method)
    # 上記の条件に当てはまらない（Bookモデル）の時、以下の処理を実行  
    else
    # 選択された検索対象（Bookモデル）に対して、search_forメソッドを使用して検索を実行し、結果を変数に代入
      @records = Book.search_for(@content, @method)
    end
  end

end
