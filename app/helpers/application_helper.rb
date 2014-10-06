module ApplicationHelper

  def get_begin_text(text, index)
    if text.match(/<beginText\/>/)
      tmp_array = text.split('<beginText/>').first.split('/')
      tmp_array[0] = "#{tmp_array.first} #{index}"
      tmp_array[1] = "#{tmp_array.second} #{index}"
      tmp_array << text.split('<beginText/>').last
      return tmp_array
    else
      return nil
    end
  end

  def get_index_hash(answers)
    number = answers.group_by(&:sort_index).count
    hash_index = Hash.new
    char = 97
    number.times do
      hash_index[char.chr] = 1
      char += 1
    end
    return hash_index
  end

  def get_number_of_joint_child(document)
    document.step_answers(12).map(&:answer).keep_if {|a| a == 'Both Parents'}.length
  end

  def get_number_of_primary_or_sole_child(document)
    document.step_answers(8).last.answer.to_i - get_number_of_joint_child(document).to_i
  end

  def get_number_of_child(document)
    if document.template.id == 1
      answer = document.step_answers(8).last
    end

    if answer.nil?
      return nil
    else
      return answer.answer
    end
  end

  def get_defendant_full_name(document)
    divorce_document = case document.template.id
      when 1
        document
      when 2
        document.divorce_document
      end
    divorce_document.step_answers(4).map(&:answer)[0..2].join(' ').squeeze(' ')
  end

  def get_plaintiff_full_name(document)
    divorce_document = case document.template.id
      when 1
        document
      when 2
        document.divorce_document
      end
    divorce_document.step_answers(3).map(&:answer)[0..2].join(' ').squeeze(' ')
  end

  def get_self(document)
    if document.template.id == 1
      answers = document.step_answers(3)
      answer = answers[answers.count - 2]
    end

    if answer.nil?
      return nil
    else
      return answer.answer
    end
  end

  def get_link_for_redirect(text, document_id)
    text.sub! /:document_id/, document_id.to_s
    path = /<link=(.*)>/.match(text).to_a.last
     "window.location='#{path}';"
  end

  def return_row_class(text)
    tmp_array = text.split('<spain/>')
    selected_number = (tmp_array.first.length + tmp_array.last.length) / 10
    if selected_number > 10
      return "col-md-12"
    else
      return "col-md-" + (selected_number + 2).to_s
    end
  end

  def get_physical_custody
    answers = TemplateStep.where(:title => 'Physical Custody /<spain/>Custodia Física').first.document_answers.first.answer
  end

  def check_physical_custody(_answers)
    _answers.first.template_step_id == TemplateStep.where(:title => 'Physical Custody /<spain/>Custodia Física').second.id
  end
end
