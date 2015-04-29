class UserController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  def edit
    check_login
    @user = current_user
  end

  def update
    check_login
    @user = current_user
    flash[:notice] = 'successfully updated.' if @user.update(user_params)
    render :edit
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:mws_market_place_id, :mws_merchant_id, :mws_auth_token)
  end
end
