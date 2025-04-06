class FavoritesController < ApplicationController
  def create
    # いいねを作成する
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: book.id)
    @favorite.save
    # いいねを作成した後、リダイレクトするのではなく、js.erbをrenderする
    render 'replace_btn'
  end

  def destroy
    # いいねを削除する
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    @favorite.destroy
    render 'replace_btn'
  end
end

# htmlファイルではなくjsファイルを読ませる必要があるため
# redirect_to request.refererを削除する
# アクション内にrenderもredirect_toもない場合、「.js.erb」を自動で探してくれる
# renderを使うと、renderの後に記載した名前のjs.erbを探しに行く
# 例→render indexの場合はそのcontrollerに紐づいているindex.js.erbを探しに行く
