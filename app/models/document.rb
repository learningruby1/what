class Document < ActiveRecord::Base

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  belongs_to :template
  accepts_nested_attributes_for :answers

  #Controller answers Action edit
  def get_or_create_answers!(next_step, direction)
    next_step = skip_steps next_step
    _answers = step_answers(next_step).sort_by(&:id) rescue nil

    if direction == 'forward' && loop_amount(next_step) > 0 && _answers.present?
      _answers.each(&:destroy)
      _answers = nil
    end

    _answers = create_next_step_answers!(next_step) if _answers.blank?
    if !_answers.blank? && !_answers.last.answer.nil? && !_answers.last.template_field.looper_option.nil? && _answers.last.template_field.looper_option  == _answers.last.answer

      _answers.each{ |a| a.destroy if a.template_field.dont_repeat? }
      _answers = step_answers(next_step).sort_by(&:id)
      _answers += create_next_step_answers!(next_step, _answers.first.toggler_offset + _answers.length)
    end
    _answers
  end

  #Controller answers Action update
  def update_answers!(answers_params)
    looper = false
    answers_params[:answers].each do |answer|
      answers.find(answer.first).update answer.last.permit(:answer)
      if answers.find(answer.first).template_field.mandatory.nil? ||
         answer.last[:answer].match(answers.find(answer.first).template_field.mandatory[:value])

        looper = answers.find(answer.first).template_field.looper_option == answer.last.permit(:answer)[:answer] if !looper && !answer.last.permit(:answer)[:answer].nil?
      else

        #WARNING: Temporary disable mandatory checking
        # errors.add(:base, 'Check the mandatory fields') if !errors.any?
        # looper = true
        looper = answers.find(answer.first).template_field.looper_option == answer.last.permit(:answer)[:answer] if !looper && !answer.last.permit(:answer)[:answer].nil?
        #######
      end
    end
    looper
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

  def create_next_step_answers!(next_step, toggler_offset=0)
    document_answers = Array.new

    if template.steps.where(:step_number => next_step).exists?
      (loop_amount(next_step) == 0 ? 1 : loop_amount(next_step)).times do
        template.steps.where(:step_number => next_step).first.fields.reverse_each do |field|

          document_answers.push answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset)
        end
      end
    end
    document_answers
  end

  def skip_steps(next_step, direction='forward')
    if template.steps.where(:step_number => next_step).exists?
      if template.steps.where(:step_number => next_step).first.render_if_field_id.present?
        begin
          while !template.steps.where(:step_number => next_step).first.render_if_field_value.nil? &&
                 template.steps.where(:step_number => next_step).first.render_if_field_value !=
                (template.steps.where(:step_number => next_step).first.render_fields.where(:document_id => id).first.try(:answer) || '') do

            next_step = direction == 'forward' ? next_step.next : next_step.pred
          end
        end rescue nil #rescue needs cause answer can be not created at the moment
      end
    end
    next_step
  end

  def step_answers(step)
    template.steps.where(:step_number => step).first.fields.map{ |f| f.document_answers.where(:document_id => id) }.flatten rescue nil
  end

  def loop_amount(step)
    template.steps.where(:step_number => step).first.amount_fields.where(:document_id => id).first.try(:answer).to_i.presence_in(1..50) || 0 rescue 0
  end
end
