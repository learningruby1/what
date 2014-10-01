class Document < ActiveRecord::Base

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  has_many :dependent_documents
  has_many :sub_documents, :through => :dependent_documents, :class_name => 'Document', :foreign_key => 'sub_document_id'

  has_one :dependant_document, :class_name => 'DependentDocument', :foreign_key => 'sub_document_id'
  has_one :divorce_document, :through => :dependant_document, :class_name => 'Document', :source => :document

  belongs_to :template
  accepts_nested_attributes_for :answers

  MANDATORY_MESSAGE = 'Check the mandatory fields /<spain/>Por favor, revisa los campos obligatorios'
  STEP_12 = "CHILDREN’S PRIOR ADDRESS"

  #Controller answers Action edit
  def prepare_answers!(next_step, direction)
    next_step = skip_steps next_step
    _answers = step_answers(next_step) rescue nil
    step = TemplateStep.find next_step rescue nil
    # Delete answers
    _looped_amount = looped_amount(next_step, _answers)
    # NOTICE amount_if_answer => amount_answer_if.answer
    if direction == 'forward' && _answers.present? && step.amount_field_id.present? &&
      (loop_amount(next_step) != _looped_amount && (step.amount_answer_if.nil? || step.amount_if_answer(self) == step.amount_field_if_option) ||
      _looped_amount != 1 && step.amount_if_answer(self) != step.amount_field_if_option)

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
  def update_answers!(answers_params, _step)
    looper = false
    answers_params[:answers].each do |answer|
      _answer = answers.find(answer.first)
      # save answer
      answer.last["answer"] = nil if answer.last["answer"].nil?

      _answer.answer = answer.last[:answer]
      _answer.answer = _answer.answer.upcase if _answer.template_field.field_type.match(/upcase$/)
      _answer.answer = _answer.answer.split(' ').map(&:titleize).join(' ') if _answer.template_field.field_type.match(/capitalize$/)
      _answer.save

      looper = add_mandatory_error unless check_mandatory(_answer, _step)
    end
    looper
  end

  def check_mandatory(_answer, _step)
    if _answer.template_field.mandatory.present? && (_answer.answer.nil? || !_answer.answer.match(_answer.template_field.mandatory[:value]))
      parent_template = template.steps.where(:step_number => _step).first.fields.where(:toggle_id => _answer.template_field.toggle_id).first
      parent_toggler = answers.where(:template_field_id => parent_template.id, :toggler_offset => _answer.toggler_offset).first
      parent_toggler = answers.where(:template_field_id => parent_template.id).first if parent_toggler.nil?
      toggle_option = _answer.template_field.toggle_option

      return false if (_answer.template_field.toggle_id.nil? || parent_toggler == _answer) && template.steps.where(:step_number => _step).first.fields.where(:sub_toggle_id => _answer.template_field.toggle_id).where.not(:sub_toggle_id => nil).count == 0

      return false if toggle_option.present? && parent_toggler.answer.present? && parent_toggler.answer.match(toggle_option) ||
                      toggle_option.nil?     && parent_toggler.answer.present? && parent_toggler.answer == '1' ||
                      toggle_option.present? && parent_toggler.answer.present? && parent_toggler.answer.match(toggle_option == 'Yes' ? '1' : '0')


      if _answer.template_field.mandatory[:template_field].present?
        parent_answer = DocumentAnswer.where(:template_field_id => _answer.template_field.mandatory[:template_field], :document_id => id, :toggler_offset => _answer.toggler_offset).order('id').first.answer

        return false if _answer.answer.nil? && parent_answer == _answer.template_field.mandatory[:toggle_option] ||
                      _answer.answer == '' && parent_answer == _answer.template_field.mandatory[:toggle_option]
      end
    end

    if _answer.sort_number == 2 && _answer.answer != ''
      parent_template = template.steps.where(:step_number => _step).first.fields.where(:toggle_id => _answer.template_field.toggle_id).first
      prev_answer = answers.where(:template_field_id => parent_template.id, :toggler_offset => _answer.toggler_offset).first.answer
      if prev_answer == '1' || prev_answer == 'Yes'
        fields_count = template.steps.where(:step_number => _answer.template_field.template_step_id).first.fields.where(:toggle_id => _answer.template_field.toggle_id).count
        answers_count = template.steps.where(:step_number => _answer.template_field.template_step_id).first.fields.map{ |f| f.document_answers.where(:document_id => id, :sort_index => _answer.sort_index) }.flatten.count rescue nil
        return false unless answers_count - 2 == (fields_count - 2) * _answer.answer.to_i
      end
    end
    true
  end

  def add_mandatory_error
    errors.add(:base, MANDATORY_MESSAGE) if !errors.any?
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

        current_step = template.steps.where(:step_number => next_step).first
        current_step.fields.reverse_each do |field|

          if field.raw_question == true
            if field.sort_index.nil?
              if i == 0 || field.dont_repeat == false
                document_answers.push answers.create(:template_field_id => field.id, :template_step_id => next_step, :toggler_offset => toggler_offset + i * template.steps.count)
              end
            else
              if i == 0 || field.dont_repeat == false
                document_answers.push answers.create(:template_field_id => field.id, :template_step_id => next_step, :toggler_offset => toggler_offset + i * template.steps.count, :sort_index => field.sort_index[0], :sort_number => field.sort_index[1, field.sort_index.length].to_i)
              end
            end
          end
        end
        break if current_step.amount_field_id.present? && current_step.amount_field_if.present? &&
                 !answers.where(:template_field_id => current_step.amount_field_if).first.answer.match(current_step.amount_field_if_option)
      end
    end
    document_answers
  end

  def return_value_for_counter(answer)
    return 0 if answer.answer.nil?
    return answer.answer.to_i
  end

  def create_hidden_answers!(next_step, answer, loop_amount, last_answer, toggler_offset=0)
    if template.steps.where(:step_number => next_step).exists?
      index = last_answer.sort_number
      counter = return_value_for_counter answer

      loop_amount.times do |i|
        template.steps.where(:step_number => next_step).first.fields.where(:amount_field_id => answer.template_field_id).reverse_each do |field|
          index += 1
          if template.steps.where(:step_number => next_step).first.title.split(' /<spain/>').first == STEP_12
            answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset + (counter + i + 1) * 2, :sort_index => last_answer.sort_index, :sort_number => index )
          else
            answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset, :sort_index => last_answer.sort_index, :sort_number => index )
          end
        end
      end
    end
  end

  def delete_hidden_answers!(next_step, answer, loop_amount, amount_field_id)
    if template.steps.where(:step_number => next_step).exists?
      tmp_answers = step_answers(next_step)
      answers = []
      tmp_answers.each do |item|
        unless item.sort_index.nil?
          if template.steps.where(:step_number => next_step).first.title.split(' /<spain/>').first == STEP_12
            answers << item if item.sort_index.include?(answer.sort_index) && item.toggler_offset >= answer.toggler_offset && item.toggler_offset <= (answer.answer.to_i + answer.toggler_offset)*2
          else
            answers << item if item.sort_index.include?(answer.sort_index) && item.toggler_offset == answer.toggler_offset
          end
        end
      end
      answers.sort!{ |a, b| b[:sort_number] <=> a[:sort_number] }
      loop_amount *= template.steps.where(:step_number => next_step).first.fields.where(:amount_field_id => amount_field_id).count
      loop_amount.times do
        answers.first.delete
        answers.shift
      end
    end
  end

  def get_last_sort_answer(step, sort_char, answer)
    tmp_answers = step_answers(step)
    answers = []
    tmp_answers.each do |item|
      unless item.sort_index.nil?
        answers << item if item.sort_index.include?(sort_char) && item.toggler_offset == answer.toggler_offset
      end
    end
    answers.sort_by!{ |item| [item.sort_index, item.sort_number] }
    answers.last
  end

  def create_or_delete_answer(value, answer, step, tmp_value, toggler_offset)
    if answer.answer.nil?
      create_hidden_answers! step, answer, value, get_last_sort_answer(step, answer.sort_index, answer), toggler_offset
      answer.update :answer => value
    else
      create_hidden_answers! step, answer, value - answer.answer.to_i, get_last_sort_answer(step, answer.sort_index, answer), toggler_offset if tmp_value < value
      delete_hidden_answers! step, answer, answer.answer.to_i - value, answer.template_field_id if tmp_value > value
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
          current_dependant_step = template.steps.where(:step_number => next_step).first
          previous_dependant_step = current_dependant_step.render_fields.where(:document_id => id).empty? ? current_dependant_step : current_dependant_step.render_fields.where(:document_id => id).first.template_field.template_step

          while !current_dependant_step.render_if_field_value.nil? &&
                (current_dependant_step.render_if_field_value != (current_dependant_step.render_fields.where(:document_id => id).first.try(:answer) || '') ||
                !previous_dependant_step.render_if_field_value.nil? && previous_dependant_step.render_if_field_value != (previous_dependant_step.render_fields.where(:document_id => id).first.try(:answer) || '') ) do

            next_step = direction == 'forward' ? next_step.next : next_step.pred

            current_dependant_step = template.steps.where(:step_number => next_step).first
            previous_dependant_step = current_dependant_step.render_fields.where(:document_id => id).empty? ? current_dependant_step : current_dependant_step.render_fields.where(:document_id => id).first.template_field.template_step
          end
        end rescue nil #rescue needs cause answer can be not created at the moment
      end
    end
    next_step
  end

  def step_answers(step)
    answers.where(:template_step_id => step).order(:id).to_a rescue nil
  end

  def loop_amount(step)
    template.steps.where(:step_number => step).first.amount_fields.this_document(self).first.try(:answer).to_i.presence_in(1..50) || 1 rescue 1
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

  def edit_answers_children_residency(_step)
    step_answers(_step+2)[2].update :answer => 'No' if step_answers(_step).first.answer == 'No' && !step_answers(_step+2).empty?
  end

  def check_child_prior_address(_step)
    answers = step_answers(_step)
    counter = answers.count / template.steps.where(:step_number => _step).first.fields.count

    counter.times do |i|
      return true if answers[i * 17 + 6].answer == 'Yes'
      return true if answers[i * 17 + 16].answer == 'Yes'
    end

    false
  end
end
