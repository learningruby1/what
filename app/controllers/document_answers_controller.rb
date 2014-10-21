class DocumentAnswersController < ApplicationController
  before_action :get_document, :only => [:edit, :update, :render_questions, :index]

  def edit
    if @document.present?
      @answers = @document.prepare_answers! params[:step].to_i, params[:direction].presence || 'forward'
      @review = params[:review]

      if @review.present? && !@answers.blank?
        @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i, :review => true)
      elsif !@answers.blank?
        @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i)
      end
      redirect_to generate_pdf_path(@document.id) if @answers.blank?
    else
      redirect_to root_path
    end
  end

  def update
    if @document.update_answers! answers_params
      redirect_to document_answer_path(@document, params[:step].to_i, :review => params[:review]), :alert => @document.errors.full_messages.first
    else
      redirect_to params[:review].present? ?
        document_review_path(@document, :scroll => params[:step]):
        document_answer_path(@document, (params[:step].to_i + (params[:direction] == 'back' ? -1 : 1)))
    end
  end

  def render_questions
    @answers = @document.hidden_answers( params[:answer_id_first], params[:answer_id_second], answers_params, params[:value] )
    @review = params[:review]

    if @review.present? && !@answers.blank?
      @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i, :review => true)
    elsif !@answers.blank?
      @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i)
    end
  end

  def index
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