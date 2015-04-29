class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #devise :trackable, :omniauthable
  devise :omniauthable, :omniauth_providers => [:amazon]

  def self.find_for_amazon_oauth(auth)
    user = User.find_by( uid: auth.uid, provider: auth.provider )
    user = User.create(name: auth.info.name, provider: auth.provider, uid: auth.uid, email: auth.info.email) unless user
    user 
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.amazon_data"] && session["devise.amazon_data"]["extra"]["raw_info"]
        user.update(email: data["email"]) if user.email.blank?
      end
    end
  end
  private
  
  def person_params
    params.require(:user).permit(:mws_market_place_id, :mws_merchant_id, :mws_auth_token)
  end
end
