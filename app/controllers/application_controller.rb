class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    Document.where(:session_uniq_token => cookies[:session_uniq_token], :user_id => nil).update_all :session_uniq_token => nil, :user_id => current_user
    cookies[:session_uniq_token] = nil
    templates_path
  end
end
