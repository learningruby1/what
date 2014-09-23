class DocumentsController < ApplicationController

  def create
    document = Template.find(params[:template_id]).documents.build
    document.assign_owner_save! cookies, (current_user if user_signed_in?)
    current_user.bind_sub_document params[:document_id], document unless params[:document_id].blank?
    redirect_to document_answer_path(document.id, 1)
  end

end