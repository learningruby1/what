class DocumentsController < ApplicationController

  def create
    current_user.bind_sub_document params[:document_id], document unless params[:document_id].blank?
    redirect_to document_answer_path(document.id, 1)
  end

end