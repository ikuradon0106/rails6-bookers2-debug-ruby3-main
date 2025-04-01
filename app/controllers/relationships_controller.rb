class RelationshipsController < ApplicationController
  def create
    #フォローを作成
    @user = User.find(params[:followed_id])


  end

  def destroy
    #フォローを削除

  end
  
# ここから下はこのcontrollerの中でしか呼び出せない
  private
# ストロングパラメータ
  def user_params
    params.require(:user).permit(:follower_id, :followed_id)
  end
end
