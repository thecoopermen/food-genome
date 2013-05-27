class SessionsController < ApplicationController
  skip_before_filter :authorize, except: [ :destroy ]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) && user.update_attribute(:login_token, SecureRandom.hex)
      session[:login_token] = user.login_token
      redirect_to root_url
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def destroy
    current_user.update_attribute(:login_token, nil)
    session[:login_token] = nil
    redirect_to login_path, notice: 'Logged out'
  end
end
