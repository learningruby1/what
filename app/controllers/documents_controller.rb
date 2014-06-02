class DocumentsController < ApplicationController
  skip_filter :authenticate_user!
  before_action :get_template, :only => [:new, :create]
  before_action :get_document, :only => [:create]

  def new
    @document = @template.documents.build
  end

  def create
    if @document.save
      redirect_to new_document_answer_path(@document)
    else
      render :action => 'new'
    end
  end

  private
  def get_template
    @template = Template.find params[:template_id]
  end

  def document_params
    params.require(:document).permit :title
  end

  def get_document
    @document = @template.documents.build document_params
    if user_signed_in?
      @document.user_id = current_user.id
    else
      @document.session_uniq_token = cookies[:session_uniq_token].present? ? cookies[:session_uniq_token] : @document.generate_session_uniq_token
      cookies[:session_uniq_token] = @document.session_uniq_token
    end
  end
end
