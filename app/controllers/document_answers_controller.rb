class DocumentAnswersController < ApplicationController
  skip_filter :authenticate_user!
  before_action :get_document, :only => [:edit, :update]

  def edit
    if @document.present?
      @answers = @document.prepare_answers! params[:step], params[:direction].presence || 'forward'
      redirect_to generate_pdf_path(@document.id) if @answers.blank?
    else
      redirect_to root_path
    end
  end

  def update
    params[:step] = params[:step].to_i.next if !@document.update_answers!(answers_params)
    if @document.errors.any?
      redirect_to document_answer_path(@document, params[:step].to_i), :alert => @document.errors.full_messages.first
    else
      redirect_to document_answer_path(@document, params[:step].to_i)
    end
  end

  private
  def get_document
    if user_signed_in?
      @document = current_user.documents.find(params[:document_id])
    else
      @document = Document.where(:id => params[:document_id], :session_uniq_token => cookies[:session_uniq_token], :user_id => nil).first
    end
  end

  def answers_params
    params.require(:document_answer).permit!
  end
end