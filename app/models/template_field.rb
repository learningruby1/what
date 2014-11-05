class TemplateField < ActiveRecord::Base
  include DivorceComplaintHelper

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory
  serialize :render_if_value

  scope :raw_question, -> { where(:raw_question => true) }

  def to_s(document=nil)
    if name.present?
      if document.to_s == Document::DIVORCE_COMPLAINT
        name.gsub! '<child_count>',           number_of_child(document) == '1' ? 'child' : 'children'
        name.gsub! '<child_count_spain>',     number_of_child(document) == '1' ? 'el menor '  : 'los menores'
        name.gsub! '<child>',                 number_of_child(document) == '1' ? 'child' : 'children'
        name.gsub! '<el_ellos>', number_of_child(document) == '1' ? 'él' : 'ellos'
        name.gsub! '<spain_self>', get_self(document) == 'Wife' ? 'esposo' : 'esposa'
        name.gsub! '<uppercase_spain_self>', get_self(document) ? 'ESPOSO' : 'ESPOSA'
        name[0] = 'C' if name[0] == 'c'
      elsif document.to_s == Document::FILED_CASE
        if name.match(/<defendant_full_name>/) || name.match(/<defendant_full_name_spain>/)
          defendant_name = get_defendant_full_name(document)
          name.gsub!('<defendant_full_name>', defendant_name)
          name.gsub!('<defendant_full_name_spain>', defendant_name)
        end
      end
    end
    name
  end

  def to_text(document, amount_index=1, index_of_radio=nil, have_no_index=false)
    amount_index -= 1
    if !header_ids.nil?
      _header_ids = header_ids.split('/')
      additional_info = document.answers.where(:template_field_id => _header_ids[0]).order('id')[amount_index].answer
      additional_info += " " + document.answers.where(:template_field_id => _header_ids[1]).order('id')[amount_index].answer.to_s if _header_ids.length > 1
      birth_day = _header_ids.length > 2 ? document.answers.where(:template_field_id => _header_ids[2]).order('id')[amount_index].answer.to_s : ''

      to_s_name = to_s(document).gsub(/<insert>/, additional_info).gsub(/<birth_date>/, birth_day)
      return to_s_name if have_no_index

      if index_of_radio.nil?
        splited_name = to_s_name.split('<spain/>')
      else
        splited_name = to_s_name.split('<option/>')[index_of_radio].split('<spain/>')
      end

      splited_name.first + (splited_name[1].present? ? "<div class='spain'>#{splited_name[1]}</div>" : '')
    else
      to_s document
    end
  end
end