class RelationshipsController < ApplicationController
  # フォローするとき
  def create
    #フォローを作成
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー外すとき
  def destroy
    #フォローを削除
    current_user.unfollow(params{:user_id})
    redirect_to request.referer
  end

  # フォロー一覧
  def user_follower
    user = User.find(params[:user_id])
    @users = user.user_follower
  end

  # フォロワー一覧
  def user_followed
    user = User.find(params[:user_id])
    @users = user.user_followed
  end
  
# ここから下はこのcontrollerの中でしか呼び出せない
  private
# ストロングパラメータ
  def user_params
    params.require(:user).permit(:follower_id, :followed_id)
  end
end
