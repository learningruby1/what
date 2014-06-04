class Document < ActiveRecord::Base

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  belongs_to :template
  accepts_nested_attributes_for :answers

  #Controller answers Action new
  def build_next_step_answers
    next_step = (answers.map{ |a| a.template_field.template_step.to_i }.max || 0) + 1

    document_answers = Array.new
    if template.steps.where(:step_number => next_step).exists?
      template.steps.where(:step_number => next_step).first.fields.each do |field|
        document_answers.push answers.build(:template_field_id => field.id)
      end
    end
    document_answers.sort_by{ |a| a.template_field.id }
  end

  #Controller answers Action create
  def create_answers!(answers_params)
    answers_params[:answers].each do |answer|
      answers.create :template_field_id => answer[:template_field_id], :answer => answer[:answer]
    end
  end

  #Controller answers Action edit
  def step_answers(step)
    begin
      template.steps.where(:step_number => step).first.fields.map{ |f| f.document_answers.where(:document_id => id) }.flatten.sort_by{ |a| a.template_field.id }
    end rescue nil
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

  def to_s
    title
  end
end
