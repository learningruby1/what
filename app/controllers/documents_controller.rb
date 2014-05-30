class DocumentsController < ApplicationController
  before_action :get_template, :only => [:new, :create]

  def index
  end

  def new
    @document = @template.documents.build
  end

  def create
    document = @template.documents.build document_params
    if document.generate_session_uniq_token! && document.save
      cookies[:session_uniq_token] = document.session_uniq_token
      redirect_to new_document_answer_path document
    else
      render :action => 'new'
    end
  end

  def destroy

  end

  private
  def get_template
    @template = Template.find params[:template_id]
  end

  def document_params
    params.require(:document).permit :title
  end
end
