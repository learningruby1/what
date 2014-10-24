class DocumentAnswersController < ApplicationController
  before_action :get_document, :only => [:edit, :update, :render_questions, :add_fields_block, :delete_fields_block, :index]

  def edit
    if @document.present?
      @current_step = params[:step]
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
    @current_step = params[:step]
    @answers = @document.hidden_answers( params[:answer_id_first], params[:answer_id_second], answers_params, params[:value], params[:step] )
    @review = params[:review]

    if @review.present? && !@answers.blank?
      @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i, :review => true)
    elsif !@answers.blank?
      @url = document_answer_update_path(@document, @answers.first.template_field.template_step.to_i)
    end
  end

  def add_fields_block
    @document.update_answers! answers_params
    @document.add_answers_block! params[:answer_id]
  end

  def delete_fields_block
    # This need only if to some child added blocks and then delete block from another child
    # @document.update_answers! answers_params
    @document.delete_answers_block! params[:answer_id]
  end

  def index
  end

  private
  def get_document
    @document = current_user.documents.find(params[:document_id])
  end

  def answers_params
    params.require(:document_answer).permit!
  end
end