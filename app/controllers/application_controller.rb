class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def check_login
    redirect_to root_path unless current_user
  end

  private

  def mws_access_keys(user)
    {
      marketplace_id: user.mws_market_place_id,
      merchant_id: user.mws_merchant_id,
      auth_token: user.mws_auth_token,
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    }
  end
end
