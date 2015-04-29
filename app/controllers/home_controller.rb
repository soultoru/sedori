class HomeController < ApplicationController
  def index
    if current_user 
      unless current_user.mws_market_place_id ||
             current_user.mws_merchant_id || current_user.mws_auth_token
        redirect_to user_path
      end
    end
  end
end
