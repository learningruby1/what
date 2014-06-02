class DocumentAnswersController < ApplicationController
  skip_filter :authenticate_user!
  before_action :get_document, :only => [:new, :create, :edit, :update]

  def new
    @answers = @document.build_next_step_answers
    redirect_to root_path if @answers.blank?
  end

  def create
    @document.create_answers! answers_params
    redirect_to new_document_answer_path(@document)
  end

  def edit
    @answers = @document.step_answers params[:step]
    new if @answers.blank?
  end

  def update
    @document.update_answers! answers_params
    redirect_to document_answer_path(@document, params[:step].to_i + 1)
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
