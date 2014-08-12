class TemplatesController < ApplicationController

  def index
    @templates = Template.all
    @documents = Document.where(:session_uniq_token => cookies[:session_uniq_token], :user_id => nil)
    @documents += current_user.documents if user_signed_in?
  end
end