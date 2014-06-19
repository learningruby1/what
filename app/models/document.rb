class Document < ActiveRecord::Base

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  belongs_to :template
  accepts_nested_attributes_for :answers

  #Controller answers Action edit
  def create_next_step_answers(next_step)
    next_step = skip_steps next_step

    document_answers = Array.new
    if template.steps.where(:step_number => next_step).exists?
      template.steps.where(:step_number => next_step).first.fields.each do |field|
        document_answers.push answers.build(:template_field_id => field.id)
      end
    end
    document_answers.sort_by{ |a| a.template_field.id }.each{ |a| a.save }
  end

  #Controller answers Action create
  def create_answers!(answers_params)
    answers_params[:answers].each do |answer|
      answers.create :template_field_id => answer[:template_field_id], :answer => answer[:answer]
    end
  end

  #Controller answers Action edit
  def step_answers(step)
    step = skip_steps step
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


  def skip_steps(next_step, action='forward')
    if template.steps.where(:step_number => next_step).exists?
      if template.steps.where(:step_number => next_step).first.render_if_field_id.present?
        begin
          while !template.steps.where(:step_number => next_step).first.render_if_field_value.nil? &&
                 template.steps.where(:step_number => next_step).first.render_if_field_value !=
                (template.steps.where(:step_number => next_step).first.render_fields.where(:document_id => id).first.try(:answer) || '') do

            next_step = action == 'forward' ? next_step.next : next_step.pred
          end
        end rescue nil #rescue needs cause answer can be not created at the moment
      end
    end
    next_step
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
