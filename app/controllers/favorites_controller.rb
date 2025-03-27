class FavoritesController < ApplicationController
  def create
    # いいねを作成する
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    redirect_back fallback_location: root_path
    
    # if request.referer == book_url(@book) #詳細画面にいいねを押した場合
      #redirect_to book_path(@book)
    #else
     # redirect_to books_path  # それ以外の場合は一覧画面にリダイレクト
    # end

  end

  def destroy
    # いいねを削除する
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    redirect_back fallback_location: root_path


    #if request.referer == book_url(@book) #詳細画面にいいねを押した場合
      #redirect_to book_path(@book)
    #else
      #redirect_to books_path  # それ以外の場合は一覧画面にリダイレクト
    
    #end

  end
end
