class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

protected

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

private

  def current_user
    @current_user ||= User.find_by_login_token(session[:login_token]) if session[:login_token]
  end
  helper_method :current_user
end
