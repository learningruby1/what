class Document < ActiveRecord::Base
  include DivorceComplaintHelper

  validates :title, :presence => true

  has_many :answers, :class_name => 'DocumentAnswer'
  has_many :dependent_documents
  has_many :sub_documents, :through => :dependent_documents, :class_name => 'Document', :foreign_key => 'sub_document_id'
  has_one :dependant_document, :class_name => 'DependentDocument', :foreign_key => 'sub_document_id'
  has_one :divorce_document, :through => :dependant_document, :class_name => 'Document', :source => :document
  belongs_to :template

  accepts_nested_attributes_for :answers

  DIVORCE_COMPLAINT = 'Complaint for Divorce /<spain/>Demanda de Divorcio'
  MANDATORY_MESSAGE = 'Check the mandatory fields /<spain/>Por favor, revisa los campos obligatorios'
  STEP_12 = "CHILDREN’S PRIOR ADDRESS"

  #Not for one child
  CHILDREN_QUESTIONS = [16, 18]



  #Controller answers Action edit
  def prepare_answers!(next_step, direction)
    next_step = skip_steps next_step
    _answers = step_answers(next_step) rescue nil

    step = TemplateStep.find next_step + template.steps.first.id - 1 rescue nil
    # Delete answers
    _looped_amount = looped_amount(next_step, _answers)
    # NOTICE amount_if_answer => amount_answer_if.answer

    if direction == 'forward' && _answers.present? && (step.amount_field_id.present? || _answers.select{|a|a.template_field.render_if_id != 0}.present?) &&
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
  def update_answers!(answers_params)
    looper = false
    answers_params[:answers].each do |answer|
      _answer = answers.find(answer.first)
      # save answer
      answer.last["answer"] = nil if answer.last["answer"].nil?

      _answer.answer = answer.last[:answer]
      _answer.answer = _answer.answer.upcase if _answer.template_field.field_type.match(/upcase$/)
      _answer.answer = _answer.answer.split(' ').map(&:titleize).join(' ') if _answer.template_field.field_type.match(/capitalize$/)
      _answer.save

      looper = add_mandatory_error unless check_mandatory(_answer)
    end
    looper
  end

  def check_mandatory(_answer)
    if _answer.template_field.mandatory.present? && (_answer.answer.nil? || !_answer.answer.match(_answer.template_field.mandatory[:value]))
      step = _answer.template_step
      parent_template = step.fields.where(:toggle_id => _answer.template_field.toggle_id).first
      parent_toggler = answers.where(:template_field_id => parent_template.id, :toggler_offset => _answer.toggler_offset).first
      parent_toggler = answers.where(:template_field_id => parent_template.id).first if parent_toggler.nil?
      toggle_option = _answer.template_field.toggle_option

      return false if (_answer.template_field.toggle_id.nil? || parent_toggler == _answer) && step.fields.where(:sub_toggle_id => _answer.template_field.toggle_id).where.not(:sub_toggle_id => nil).count == 0

      return false if toggle_option.present? && parent_toggler.answer.present? && parent_toggler.answer.match(toggle_option) ||
                      toggle_option.nil?     && parent_toggler.answer.present? && parent_toggler.answer == '1' ||
                      toggle_option.present? && parent_toggler.answer.present? && parent_toggler.answer.match(toggle_option == 'Yes' ? '1' : 'false')

      if _answer.template_field.mandatory[:template_field].present?
        parent_answer = DocumentAnswer.where(:template_field_id => _answer.template_field.mandatory[:template_field], :document_id => id, :toggler_offset => _answer.toggler_offset).order('id').first.answer

        return false if _answer.answer.nil? && parent_answer == _answer.template_field.mandatory[:toggle_option] ||
                       _answer.answer == '' && parent_answer == _answer.template_field.mandatory[:toggle_option]
      end
    end

    if _answer.sort_number == 2 && _answer.answer != ''
      step = _answer.template_step
      parent_template = step.fields.where(:toggle_id => _answer.template_field.toggle_id).first
      prev_answer = answers.where(:template_field_id => parent_template.id, :toggler_offset => _answer.toggler_offset).first.answer
      if prev_answer == '1' || prev_answer == 'Yes'

        fields_count = step.fields.where(:toggle_id => _answer.template_field.toggle_id).count
        answers_count = step.fields.map{ |f| f.document_answers.where(:document_id => id, :sort_index => _answer.sort_index, :toggler_offset => _answer.toggler_offset) }.flatten.count rescue nil

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
          if field.raw_question == true && (i == 0 || field.dont_repeat == false)
            params = { :template_field_id => field.id, :template_step_id => field.template_step.id, :toggler_offset => (toggler_offset + i * template.steps.count) }
            params.merge!({ :sort_index => field.sort_index[0], :sort_number => field.sort_index[1, field.sort_index.length].to_i }) if !field.sort_index.nil?

            template_field = TemplateField.find(params[:template_field_id])
            depend_answer = TemplateField.find(template_field.render_if_id).document_answers.where(:document_id => id).first if template_field.render_if_id.present?

            document_answers.push(answers.create(params)) if template_field.render_if_id.nil? || depend_answer.answer.match(template_field.render_if_value)
          end
        end
        break if current_step.amount_field_id.present? && current_step.amount_field_if.present? &&
                 answers.where(:template_field_id => current_step.amount_field_if).exists? &&
                 !answers.where(:template_field_id => current_step.amount_field_if).first.answer.match(current_step.amount_field_if_option)
      end
    end
    document_answers
  end

  def return_value_for_counter(answer)
    return 0 if answer.answer.nil?
    return answer.answer.to_i
  end

  def create_hidden_answers!(answer, loop_amount, last_answer, toggler_offset=0)
    step = answer.template_step
    if step.present?
      index = last_answer.sort_number
      counter = return_value_for_counter answer

      loop_amount.times do |i|
        step.fields.where(:amount_field_id => answer.template_field_id).reverse_each do |field|
          index += 1
          if step.title.split(' /<spain/>').first == STEP_12
            answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset + (counter + i + 1) * 2, :sort_index => last_answer.sort_index, :sort_number => index, :template_step_id => answer.template_step_id )
          else
            answers.create(:template_field_id => field.id, :toggler_offset => toggler_offset, :sort_index => last_answer.sort_index, :sort_number => index, :template_step_id => answer.template_step_id )
          end
        end
      end
    end
  end

  def delete_hidden_answers!(next_step, answer, loop_amount, amount_field_id)
    step = answer.template_step
    if step.present?
      tmp_answers = step_answers(next_step)
      answers = []
      tmp_answers.each do |item|
        unless item.sort_index.nil?
          if step.title.split(' /<spain/>').first == STEP_12
            answers << item if item.sort_index.include?(answer.sort_index) && item.toggler_offset >= answer.toggler_offset && item.toggler_offset <= (answer.answer.to_i + answer.toggler_offset)*2
          else
            answers << item if item.sort_index.include?(answer.sort_index) && item.toggler_offset == answer.toggler_offset
          end
        end
      end
      answers.sort!{ |a, b| b[:sort_number] <=> a[:sort_number] }
      loop_amount *= step.fields.where(:amount_field_id => amount_field_id).count
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
        if answer.template_step.title.split(' /<spain/>').first == STEP_12

          answers << item if item.sort_index.include?(sort_char) && item.toggler_offset == answer.toggler_offset + (answer.answer.to_i * 2)
        else
          answers << item if item.sort_index.include?(sort_char) && item.toggler_offset == answer.toggler_offset
        end
      end
    end
    answers.sort_by!{ |item| [item.sort_index, item.sort_number] }
    answers.last
  end

  def create_or_delete_answer(value, answer, tmp_value)
    toggler_offset = answer.toggler_offset
    step = answer.template_step_id
    if answer.answer.nil?
      create_hidden_answers! answer, value, get_last_sort_answer(step, answer.sort_index, answer), toggler_offset
      answer.update :answer => value
    else
      create_hidden_answers! answer, value - answer.answer.to_i, get_last_sort_answer(step, answer.sort_index, answer), toggler_offset if tmp_value < value
      delete_hidden_answers! step, answer, answer.answer.to_i - value, answer.template_field_id if tmp_value > value
      answer.update :answer => value
    end
  end

  def skip_steps(next_step, direction='forward')
    if template.steps.where(:step_number => next_step).exists? && template.steps.where(:step_number => next_step).first.render_if_field_id.present?
      begin
        while cant_render?(template.steps.where(:step_number => next_step).first)
          next_step = direction == 'forward' ? next_step.next : next_step.pred
        end
      end rescue nil
    end

    # if direction == 'back'
    #   child_count = return_step('Children /<spain/>Menores').document_answers.last
    #   return next_step if child_count.nil?

    #   prev_step = return_step(next_step.to_i + template.steps.first.id - 1)
    #   if (prev_step.title.split(' /<spain/>').first == 'Legal Custody' || prev_step.title.split(' /<spain/>').first == 'Physical Custody') && child_count.answer == '1'
    #     return next_step.to_i + template.steps.first.id - 2
    #   end
    # end

    next_step
  end

  def cant_render?(step)
    return true if number_of_child(self) == '1' && CHILDREN_QUESTIONS.include?(step.step_number)
    return cant_render_body? step
  end

  def cant_render_body?(step)
    dependant_stages_status = []
    if step.render_if_field_id.present?
      step.render_if_field_id.split('/').each_with_index do |e, i|
        dependant_stages_status << cant_render_body?(TemplateField.find(e.to_i).template_step)
      end
      current_dependent_status = []
      step.render_if_field_id.split('/').each_with_index do |e, i|
        current_dependent_status << (TemplateField.find(e.to_i).document_answers.where(:document_id => id).map(&:answer)).select { |element| element =~ Regexp.new(step.render_if_field_value.split('/')[i]) }.empty?
      end
       !(current_dependent_status.include?(false) && dependant_stages_status.include?(false))
    else
      false
    end
  end

  def step_answers(step)
    step = step.id if step.kind_of?(TemplateStep)
    answers.where(:template_step_id => step + template.steps.first.id - 1).order(:id).to_a rescue nil
  end

  def loop_amount(step)
    template.steps.where(:step_number => step).first.amount_fields.this_document(self).first.try(:answer).to_i.presence_in(1..50) || 1 rescue 1
  end

  def looped_amount(step, _answers)
    selected_array = _answers.select{ |item| item.template_field.raw_question == true }
    selected_array.count / template.steps.where(:step_number => step).first.fields.raw_question.count rescue 0
  end

  def assign_owner_save!(cookies, user=nil)
    if !user.nil?
      self.user_id = user.id
    else
      cookies[:session_uniq_token] = generate_session_uniq_token if !cookies[:session_uniq_token].present?
      self.session_uniq_token = cookies[:session_uniq_token]
    end
    save!
  end

  def return_step(_param)
    _param.kind_of?(String) ? template.steps.where(:title => _param).first : template.steps.find(_param)
  end
end