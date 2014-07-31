class DocumentsController < ApplicationController
  skip_filter :authenticate_user!

  def create
    document = Template.find(params[:template_id]).documents.build
    document.assign_owner_save! cookies, (current_user if user_signed_in?)
    redirect_to document_answer_path(document.id, 1)
  end
end