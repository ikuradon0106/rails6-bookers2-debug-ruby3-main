class BookCommentsController < ApplicationController

  def create
    # コメントを作成する
    book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = book.id
    @comment.save
    # redirect_to request.referer
  end

  def destroy
    # コメントを削除する
    @comment = BookComment.find(params[:id])
    @comment.destroy
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end

#非同期通信のため、redirect_to request.refererは削除
