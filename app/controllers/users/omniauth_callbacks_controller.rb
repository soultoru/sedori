class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def amazon
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_amazon_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: 'Amazon') if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.amazon_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
