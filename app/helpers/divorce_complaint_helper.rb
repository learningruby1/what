module DivorceComplaintHelper

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

  def number_of_child(document)
    document.step_answers(8).last.try :answer if document.to_s == Document::DIVORCE_COMPLAINT
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
    document.step_answers(3)[document.step_answers(3).count - 2].try :answer if document.to_s == Document::DIVORCE_COMPLAINT
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


  def replace_main_text(_document, _answers, text, _amount_index, _index_of_radio, _real_answer)
    if check_physical_custody(_answers)
      if get_physical_custody == 'Yes' && number_of_child(_document) != '1'
        text.gsub!('the child lives', 'the children live')
        text.gsub!('el menor vive', 'los menores viven')
      end
    end

    text = _real_answer.template_field.to_text(_document, _amount_index, _index_of_radio) if text.match(/<insert>/)

    unless get_self(_document).nil?
      if text.match(/<spain_self>/) || text.match(/<uppercase_spain_self>/)
        if get_self(_document) == 'Wife'
          text.gsub!('<spain_self>', 'esposo')
          text.gsub!('<uppercase_spain_self>', 'ESPOSO')
        else
          text.gsub!('<spain_self>', 'esposa')
          text.gsub!('<uppercase_spain_self>', 'ESPOSA')
        end
      end
    end

    unless number_of_child(_document).nil?
      count = number_of_child(_document).to_i
      sole_count = get_number_of_primary_or_sole_child(_document)
      if text.match(/<child_count>/) || text.match(/<child_count_spain>/) || text.match(/<residency_child>/) || text.match(/<residency_child_second>/)
        if count == 1
          text.gsub!('<child_count>', 'the child')
          text.gsub!('<child_count_spain>', 'del menor')
          text.gsub!('<residency_child>', 'El menor debe')
          text.gsub!('<residency_child_second>', 'Ha vivido el menor')
          text.gsub!('<el_ellos>', 'él')
          text[0] = 'T' if text[0] == 't'
        else
          text.gsub!('<child_count>', 'children')
          text.gsub!('<child_count_spain>', 'de los menores')
          text.gsub!('<residency_child>', 'Los menores deben')
          text.gsub!('<residency_child_second>', 'Han vivido los menores')
          text.gsub!('<el_ellos>', 'ellos')
          text[0] = 'C' if text[0] == 'c'
        end
      end

      if text.match(/<uppercase_child>/) || text.match(/<uppercase_child_spain>/)
        if count == 1
          text.gsub!('<uppercase_child>', 'CHILD')
          text.gsub!('<uppercase_child_spain>', 'DEL MENOR')
        else
          text.gsub!('<uppercase_child>', 'CHILDREN')
          text.gsub!('<uppercase_child_spain>', 'DE LOS MENORES')
        end
      end

      if text.match(/<child_number_count>/) || text.match(/<child_number_count_spain>/)
        if count == 1
          text.gsub!('<child_count>', '1 child')
          text.gsub!('<child_count_spain>', '1 menor ')
        else
          text.gsub!('<child_count>', "#{count} children")
          text.gsub!('<child_count_spain>', "#{count} menores")
        end
      end

      if text.match(/<child_sole_count>/) || text.match(/<child_sole_count_spain>/)
        if sole_count == 1
          text.gsub!('<child_sole_count>', '1 child')
          text.gsub!('<child_sole_count_spain>', '1 menor ')
        else
          text.gsub!('<child_sole_count>', "#{sole_count} children")
          text.gsub!('<child_sole_count_spain>', "#{sole_count} menores")
        end
      end

      if text.match(/<child_percentage_sole>/) || text.match(/<child_percentage_sole_spain>/)
        case sole_count
        when 1
          text.gsub!('<child_percentage_sole_spain>', '1 niño 18%')
          text.gsub!('<child_percentage_sole>', '1 child 18%')
        when 2
          text.gsub!('<child_percentage_sole_spain>', '2 niños 25%')
          text.gsub!('<child_percentage_sole>', '2 children 25%')
        when 3
          text.gsub!('<child_percentage_sole_spain>', '3 niños 29%')
          text.gsub!('<child_percentage_sole>', '3 children 29%')
        when 4
          text.gsub!('<child_percentage_sole_spain>', '4 niños 31%')
          text.gsub!('<child_percentage_sole>', '4 children 31%')
        when 5
          text.gsub!('<child_percentage_sole_spain>', '5 niños 33%')
          text.gsub!('<child_percentage_sole>', '5 children 33%')
        when 6
          text.gsub!('<child_percentage_sole_spain>', '6 niños 35%')
          text.gsub!('<child_percentage_sole>', '6 children 35%')
        when 7
          text.gsub!('<child_percentage_sole_spain>', '7 niños 37%')
          text.gsub!('<child_percentage_sole>', '7 children 37%')
        when 8
          text.gsub!('<child_percentage_sole_spain>', '8 niños 39%')
          text.gsub!('<child_percentage_sole>', '8 children 39%')
        when 9
          text.gsub!('<child_percentage_sole_spain>', '9 niños 41%')
          text.gsub!('<child_percentage_sole>', '9 children 41%')
        end
      end
    end

    if text.match(/<defendant_full_name>/) || text.match(/<defendant_full_name_spain>/)
      defendant_name = get_defendant_full_name(_document)
      text.gsub!('<defendant_full_name>', defendant_name)
      text.gsub!('<defendant_full_name_spain>', defendant_name)
    end

    text
  end
end

