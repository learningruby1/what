class Document < ActiveRecord::Base

  has_many :answers, -> { includes(:template_field) }, :class_name => 'DocumentAnswer'
  belongs_to :template
  accepts_nested_attributes_for :answers

  #Controller answers Action new
  def build_next_step_answers
    next_step = (answers.map{ |a| a.template_field.step_number }.max || 0) + 1

    document_answers = Array.new
    template.fields.where(:step_number => next_step).each do |field|
      document_answers.push answers.build(:template_field_id => field.id)
    end
    document_answers
  end

  #Controller answers Action create
  def create_answers!(answers_params)
    answers_params[:answers].each do |answer|
      answers.create :template_field_id => answer[:template_field_id], :answer => answer[:answer]
    end
  end

  #Controller answers Action edit
  def step_answers(step)
    answers.where('template_fields.step_number' => step)
  end

  #Controller answers Action update
  def update_answers!(answers_params)
    answers_params[:answers].each do |answer|
      answers.find(answer.first).update answer.last.permit(:answer)
    end
  end


  def generate_session_uniq_token
    begin
      session_uniq_token = SecureRandom.hex
    end while Document.exists?(:session_uniq_token => session_uniq_token)
    session_uniq_token
  end

  def has_next_step?(current_step)
    template.fields.where(:step_number => current_step + 1).exists?
  end

  def to_s
    title
  end
end
