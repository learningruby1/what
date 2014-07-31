class Document < ActiveRecord::Base

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  belongs_to :template
  accepts_nested_attributes_for :answers

  #Controller answers Action edit
  def prepare_answers!(next_step, direction)
    next_step = skip_steps next_step
    _answers = step_answers(next_step) rescue nil

    if direction == 'forward' && loop_amount(next_step) != looped_amount(next_step, _answers) && _answers.present?
      _answers.each(&:destroy)
      _answers = nil
    end

    _answers = create_next_step_answers!(next_step) if _answers.blank?

    if !_answers.blank? && !_answers.last.answer.nil? &&
       !_answers.last.template_field.looper_option.nil? &&
        _answers.last.template_field.looper_option  == _answers.last.answer

      _answers.each{ |a| a.destroy if a.template_field.dont_repeat? }
      _answers = step_answers(next_step)
      _answers += create_next_step_answers!(next_step, _answers.first.toggler_offset + _answers.length)
    end

    _answers
  end

  #Controller answers Action update
  def update_answers!(answers_params)
    looper = false
    answers_params[:answers].each do |answer|

      _answer = answers.find(answer.first)
      step_number = _answer.template_field.template_step.step_number
      # save answer
      _answer.update answer.last.permit(:answer)
      # upcase
      _answer.update :answer => _answer.answer.upcase if _answer.template_field.field_type.match(/upcase$/)

      # mandatory checking
      if !_answer.template_field.mandatory.nil? && answer.last[:answer].nil? || !_answer.template_field.mandatory.nil? &&
         !answer.last[:answer].match(_answer.template_field.mandatory[:value])

        if !_answer.template_field.toggle_id.nil?
          if !_answer.template_field.toggle_option.nil? &&
             step_answers(step_number).keep_if{ |a| a.template_field.toggle_id == _answer.template_field.toggle_id }.first.answer.match(_answer.template_field.toggle_option) ||
             step_answers(step_number).keep_if{ |a| a.template_field.toggle_id == _answer.template_field.toggle_id && a.toggler_offset == _answer.toggler_offset }.first.answer == '1'

            looper = add_mandatory_error
          end rescue looper = add_mandatory_error
        else
          looper = add_mandatory_error
        end
      else
        looper = _answer.template_field.looper_option == answer.last.permit(:answer)[:answer] if !looper && !answer.last.permit(:answer)[:answer].nil?
      end
    end
    looper
  end

  def add_mandatory_error
    errors.add(:base, 'Check the mandatory fields /<spain/>Por favor, revisa los campos obligatorios') if !errors.any?
    true
  end

  def generate_session_uniq_token
    begin
      session_uniq_token = SecureRandom.hex
    end while Document.exists?(:session_uniq_token => session_uniq_token)
    session_uniq_token
  end

  def to_s
    template.name
  end

  def create_next_step_answers!(next_step, toggler_offset=0)
    document_answers = Array.new

    if template.steps.where(:step_number => next_step).exists?
      loop_amount(next_step).times do |i|
        template.steps.where(:step_number => next_step).first.fields.reverse_each do |field|

          if field.raw_question == true
            if field.sort_index.nil?
              if i == 0 || field.dont_repeat == false
                document_answers.push answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset + i * template.steps.count)
              end
            else
              if i == 0 || field.dont_repeat == false
                document_answers.push answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset + i * template.steps.count, :sort_index => field.sort_index[0], :sort_number => field.sort_index[1, field.sort_index.length].to_i)
              end
            end
          end
        end
      end
    end
    document_answers
  end

  def create_hidden_answers!(next_step, amount_field_id, loop_amount, last_answer, toggler_offset=0)
    if template.steps.where(:step_number => next_step).exists?
      index = last_answer.sort_number
      loop_amount.times do
        template.steps.where(:step_number => next_step).first.fields.where(:amount_field_id => amount_field_id).reverse_each do |field|
          index += 1
          answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset, :sort_index => last_answer.sort_index, :sort_number => index )
        end
      end
    end
  end

  def delete_hidden_answers!(next_step, sort_char, loop_amount, amount_field_id)
    if template.steps.where(:step_number => next_step).exists?
      tmp_answers = step_answers(next_step)
      answers = []
      tmp_answers.each do |item|
        answers << item if item.sort_index.include?(sort_char)
      end
      answers.sort!{ |a, b| b[:sort_number] <=> a[:sort_number] }
      loop_amount *= template.steps.where(:step_number => next_step).first.fields.where(:amount_field_id => amount_field_id).count
      loop_amount.times do
        answers.first.delete
        answers.shift
      end
    end
  end

  def get_last_sort_answer(step, sort_char)
    tmp_answers = step_answers(step)
    answers = []
    tmp_answers.each do |item|
      answers << item if item.sort_index.include?(sort_char)
    end
    answers.sort_by!{ |item| [item.sort_index, item.sort_number] }
    answers.last
  end

  def create_or_delete_answer(value, answer, step, tmp_value)
     if answer.answer.nil?
      answer.update :answer => value
      create_hidden_answers! step, answer.template_field_id, value, get_last_sort_answer(step, answer.sort_index)
    else
      create_hidden_answers! step, answer.template_field_id, value - answer.answer.to_i, get_last_sort_answer(step, answer.sort_index) if tmp_value < value
      delete_hidden_answers! step, answer.sort_index, answer.answer.to_i - value, answer.template_field_id if tmp_value > value
      answer.update :answer => value
    end
  end

  def step_answers(step)
    template.steps.where(:step_number => step).first.fields.map{ |f| f.document_answers.where(:document_id => id) }.flatten rescue nil
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
    template.steps.where(:step_number => step).first.fields.map{ |f| f.document_answers.where(:document_id => id) }.flatten.sort_by(&:id) rescue nil
  end

  def loop_amount(step)
    template.steps.where(:step_number => step).first.amount_fields.where(:document_id => id).first.try(:answer).to_i.presence_in(1..50) || 1 rescue 1
  end

  def looped_amount(step, _answers)
    _answers.count / template.steps.where(:step_number => step).first.fields.count rescue 0
  end


  def assign_owner_save!(cookies, user=nil)
    if !user.nil?
      self.user_id = user.id
    else
      cookies[:session_uniq_token] = generate_session_uniq_token if !cookies[:session_uniq_token].present?
      self.session_uniq_token  = cookies[:session_uniq_token]
    end
    save!
  end
end
