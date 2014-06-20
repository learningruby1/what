class DocumentAnswersController < ApplicationController
  skip_filter :authenticate_user!
  before_action :get_document, :only => [:edit, :update]

  def edit
    @answers = @document.step_answers(params[:step]).sort_by(&:id) rescue nil
    @answers = @document.create_next_step_answers(params[:step]) if @answers.blank?
    redirect_to(templates_path, :notice => 'Document complete') if @answers.blank?
  end

  def update
    @document.update_answers! answers_params
    redirect_to document_answer_path(@document, params[:step].to_i.next)
  end

  private
  def get_document
    if user_signed_in?
      @document = current_user.documents.find(params[:document_id])
    else
      @document = Document.where(:id => params[:document_id], :session_uniq_token => cookies[:session_uniq_token]).first
    end
  end

  def answers_params
    params.require(:document_answer).permit!
  end
end
