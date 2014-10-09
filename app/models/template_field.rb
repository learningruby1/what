class TemplateField < ActiveRecord::Base
  include DivorceComplaintHelper

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory
  serialize :render_if_value

  scope :raw_question, -> { where(:raw_question => true) }

  def to_s(document=nil)
    if document.to_s == Document::DIVORCE_COMPLAINT
      name.gsub! '<child_count>',           number_of_child(document) == '1' ? 'child' : 'children'
      name.gsub! '<child_count_spain>',     number_of_child(document) == '1' ? 'el menor '  : 'los menores'
      name.gsub! '<el_ellos>', number_of_child(document) == '1' ? 'él' : 'ellos'

      name.gsub! '<spain_self>', get_self(document) == 'Wife' ? 'esposo' : 'esposa'
      name.gsub! '<uppercase_spain_self>', get_self(document) ? 'ESPOSO' : 'ESPOSA'
    end
    name
  end

  def to_text(document, amount_index, index_of_radio = nil)
    amount_index -= 1

    if !header_ids.nil?
      _header_ids = header_ids.split('/')
      additional_info = document.answers.where(:template_field_id => _header_ids.first).order('id')[amount_index].answer
      additional_info += " " + document.answers.where(:template_field_id => _header_ids.last).order('id')[amount_index].answer.to_s if _header_ids.length > 1

      text = ''
      tmp_array = index_of_radio.nil? ? tmp_array = to_s(document).split('<spain/>') : tmp_array = to_s(document).split('<option/>')
      tmp_array = tmp_array[index_of_radio].split('<spain/>') unless index_of_radio.nil?
      text += tmp_array.first.gsub(/<insert>/, additional_info) if !to_s(document).nil?
      text += '<div class="spain">' + tmp_array.last.gsub(/<insert>/, additional_info) + '</div>'
    else
      to_s(document)
    end
  end
end
