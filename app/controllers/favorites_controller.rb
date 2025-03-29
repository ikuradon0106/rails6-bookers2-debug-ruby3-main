class FavoritesController < ApplicationController
  def create
    # いいねを作成する
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save
    redirect_to request.referer

  end

  def destroy
    # いいねを削除する
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    redirect_to request.referer

  end
end
