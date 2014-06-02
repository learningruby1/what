class TemplatesController < ApplicationController
  skip_filter :authenticate_user!

  def index
    @templates = Template.all
    @documents = Document.where(:session_uniq_token => cookies[:session_uniq_token])
    @documents += Document.where(:user_id => current_user) if user_signed_in?
  end
end