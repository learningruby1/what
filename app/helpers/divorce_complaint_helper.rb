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

  def number_of_child(document)
    document.step_answers(8).last.try :answer if document.to_s == Document::DIVORCE_COMPLAINT
  end

  def get_number_of_joint_child(document)
    if document.step_answers(17).map(&:answer).include? 'Yes'
      document.step_answers(18).map(&:answer).keep_if {|a| a.to_s.downcase == 'both parents'}.present? ? number_of_child(document).to_i : 0
    else
      document.step_answers(18).map(&:answer).keep_if {|a| a.to_s.downcase == 'both parents'}.length
    end
  end

  def get_number_of_primary_or_sole_child(document)
    number_of_child(document).to_i - get_number_of_joint_child(document).to_i
  end

  def get_percentage_for_children(count)
    case count
    when 1
      18
    when 2
      25
    else
      29 + (count-3)*2
    end
  end

  def get_defendant_full_name(document)
    divorce_document = case document.to_s
      when Document::DIVORCE_COMPLAINT
        document
      when Document::FILED_CASE
        document.divorce_document
      when Document::AFTER_SERVICE
        document.divorce_document.divorce_document
      end
    divorce_document.step_answers(4).map(&:answer)[0..2].join(' ').squeeze(' ')
  end

  def get_plaintiff_full_name(document)
    divorce_document = case document.to_s
      when Document::DIVORCE_COMPLAINT
        document
      when Document::FILED_CASE
        document.divorce_document
      end
    divorce_document.step_answers(3).map(&:answer)[0..2].join(' ').squeeze(' ')
  end

  def get_self(document)
    document.step_answers(3)[document.step_answers(3).count - 2].try :answer if document.to_s == Document::DIVORCE_COMPLAINT
  end

  def get_link_for_redirect(text, document_id, answer)
    answer.update :answer => nil
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

  def return_start_end_year(answer)
    case answer.template_field.field_type
    when /date_future/
      return [Time.now.year, Time.now.year + 10]
    when /date_year_born/
      return [Time.now.year, Time.now.year + 1]
    when /date_without_day/
      return [Time.now.year - 5, Time.now.year]
    when /date_year_only/
      return [Time.now.year, Time.now.year - 1]
    when /date_after_born/
      born_year = TemplateField.find(answer.template_field.header_ids.to_i).document_answers.where(:document_id => answer.document.id, :toggler_offset => (answer.toggler_offset / 1000) * 1000).first.answer.to_date.year
      born_year = born_year < Time.now.year - 5 ? Time.now.year - 5 : born_year
      return [born_year, Time.now.year]
    when /date_for_child/
      return [Time.now.year, Time.now.year - 18]
    when /date_birthday/
      return [Time.now.year - 13, Time.now.year - 100]
    when /date/
      return [Time.now.year, Time.now.year - 100]
    end
  end


  def to_humanize(_document, text)
    return text if text.blank? || _document.nil?
    text.gsub!('<defendant_full_name>', get_defendant_full_name(_document))

    unless get_self(_document).nil?
      if get_self(_document) == 'Wife'
        text.gsub!('<spain_self>', 'esposo')
        text.gsub!('<uppercase_spain_self>', 'ESPOSO')
      else
        text.gsub!('<spain_self>', 'esposa')
        text.gsub!('<uppercase_spain_self>', 'ESPOSA')
      end
    end

    unless number_of_child(_document).nil?
      count = number_of_child(_document).to_i
      sole_count = get_number_of_primary_or_sole_child(_document)
      joint_count = get_number_of_joint_child(_document)
      if count == 1
        text.gsub!('<child_lives>', 'the child lives')
        text.gsub!('<child_lives_spain>', 'el menor vive')

        text.gsub!('<child>', 'child')
        text.gsub!('<child_count>', 'the child')
        text.gsub!('<child_count_spain>', 'del menor')

        text.gsub!('<residency_child>', 'El menor debe')
        text.gsub!('<residency_child_second>', 'Ha vivido el menor')

        text.gsub!('<el_ellos>', 'él')
      else
        text.gsub!('<child_lives>', 'the children live')
        text.gsub!('<child_lives_spain>', 'los menores viven')

        text.gsub!('<child_count>', 'children')
        text.gsub!('<child_count_spain>', 'de los menores')
        text.gsub!('<child>', 'children')

        text.gsub!('<residency_child>', 'Los menores deben')
        text.gsub!('<residency_child_second>', 'Han vivido los menores')

        text.gsub!('<el_ellos>', 'ellos')
      end

      if sole_count == 1
        text.gsub!('<child_sole_count>', '1 child')
        text.gsub!('<child_sole_count_spain>', '1 menor ')
      else
        text.gsub!('<child_sole_count>', "#{sole_count} children")
        text.gsub!('<child_sole_count_spain>', "#{sole_count} menores")
      end

      if sole_count == 1
        text.gsub!('<child_percentage_sole>', '1 child 18%')
        text.gsub!('<child_percentage_sole_spain>', '1 niño 18%')
      else
        text.gsub!('<child_percentage_sole>', "#{sole_count} children #{get_percentage_for_children(sole_count)}%")
        text.gsub!('<child_percentage_sole_spain>', "#{sole_count} niños #{get_percentage_for_children(sole_count)}%")
      end

      if joint_count == 1
        text.gsub!('<child_joint_count>', '1 child')
        text.gsub!('<child_joint_count_spain>', '1 menor ')
      else
        text.gsub!('<child_joint_count>', "#{joint_count} children")
        text.gsub!('<child_joint_count_spain>', "#{joint_count} menores")
      end
    end

    text[0] = text[0].upcase
    #First letter after <option/> or <spain/> will be upcase
    text.gsub!(/\/>\w{1}/){ |m| m.upcase }
    text
  end

  # def replace_main_text(_document, _answers, text, _amount_index, _index_of_radio, _real_answer)
  #   if _answers.first.template_step_id == 18
  #     if number_of_child(_document) != '1' && TemplateStep.where(:title => 'Same Legal Custody /<spain/>Misma Custodia Legal').first.document_answers.where(:document_id => _document.id).first.answer == 'Yes'
  #       text.gsub!('the child lives', 'the children live')
  #       text.gsub!('el menor vive', 'los menores viven')
  #     end
  #   end

  #   text = _real_answer.template_field.to_text(_document, _amount_index, _index_of_radio) if text.match(/<insert>/) && _real_answer.present?

  #   unless get_self(_document).nil?
  #     if get_self(_document) == 'Wife'
  #       text.gsub!('<spain_self>', 'esposo')
  #       text.gsub!('<uppercase_spain_self>', 'ESPOSO')
  #     else
  #       text.gsub!('<spain_self>', 'esposa')
  #       text.gsub!('<uppercase_spain_self>', 'ESPOSA')
  #     end
  #   end

  #   unless number_of_child(_document).nil?
  #     count = number_of_child(_document).to_i
  #     sole_count = get_number_of_primary_or_sole_child(_document)
  #     joint_count = get_number_of_joint_child(_document)
  #     if count == 1
  #       text.gsub!('<child_count>', 'the child')
  #       text.gsub!('<child>', 'child')
  #       text.gsub!('<child_count_spain>', 'del menor')
  #       text.gsub!('<residency_child>', 'El menor debe')
  #       text.gsub!('<residency_child_second>', 'Ha vivido el menor')
  #       text.gsub!('<el_ellos>', 'él')
  #       text[0] = 'T' if text[0] == 't'
  #     else
  #       text.gsub!('<child_count>', 'children')
  #       text.gsub!('<child>', 'children')
  #       text.gsub!('<child_count_spain>', 'de los menores')
  #       text.gsub!('<residency_child>', 'Los menores deben')
  #       text.gsub!('<residency_child_second>', 'Han vivido los menores')
  #       text.gsub!('<el_ellos>', 'ellos')
  #       text[0] = 'C' if text[0] == 'c'
  #     end


  #     if text.match(/<uppercase_child>/) || text.match(/<uppercase_child_spain>/)
  #       if count == 1
  #         text.gsub!('<uppercase_child>', 'CHILD')
  #         text.gsub!('<uppercase_child_spain>', 'DEL MENOR')
  #       else
  #         text.gsub!('<uppercase_child>', 'CHILDREN')
  #         text.gsub!('<uppercase_child_spain>', 'DE LOS MENORES')
  #       end
  #     end

  #     if text.match(/<child_number_count>/) || text.match(/<child_number_count_spain>/)
  #       if count == 1
  #         text.gsub!('<child_count>', '1 child')
  #         text.gsub!('<child_count_spain>', '1 menor ')
  #       else
  #         text.gsub!('<child_count>', "#{count} children")
  #         text.gsub!('<child_count_spain>', "#{count} menores")
  #       end
  #     end

  #     if text.match(/<child_sole_count>/) || text.match(/<child_sole_count_spain>/)
  #       if sole_count == 1
  #         text.gsub!('<child_sole_count>', '1 child')
  #         text.gsub!('<child_sole_count_spain>', '1 menor ')
  #       else
  #         text.gsub!('<child_sole_count>', "#{sole_count} children")
  #         text.gsub!('<child_sole_count_spain>', "#{sole_count} menores")
  #       end
  #     end

  #     if text.match(/<child_percentage_sole>/) || text.match(/<child_percentage_sole_spain>/)
  #       if sole_count == 1
  #         text.gsub!('<child_percentage_sole>', '1 child 18%')
  #         text.gsub!('<child_percentage_sole_spain>', '1 niño 18%')
  #       else
  #         text.gsub!('<child_percentage_sole>', "#{sole_count} children #{get_percentage_for_children(sole_count)}%")
  #         text.gsub!('<child_percentage_sole_spain>', "#{sole_count} niños #{get_percentage_for_children(sole_count)}%")
  #       end
  #     end

  #     if text.match(/<child_joint_count>/) || text.match(/<child_joint_count_spain>/)
  #       if joint_count == 1
  #         text.gsub!('<child_joint_count>', '1 child')
  #         text.gsub!('<child_joint_count_spain>', '1 menor ')
  #       else
  #         text.gsub!('<child_joint_count>', "#{joint_count} children")
  #         text.gsub!('<child_joint_count_spain>', "#{joint_count} menores")
  #       end
  #     end
  #   end

  #   if text.match(/<defendant_full_name>/) || text.match(/<defendant_full_name_spain>/)
  #     defendant_name = get_defendant_full_name(_document)
  #     text.gsub!('<defendant_full_name>', defendant_name)
  #     text.gsub!('<defendant_full_name_spain>', defendant_name)
  #   end

  #   text
  # end
end

