class TemplateField < ActiveRecord::Base

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory

  scope :raw_question_true, -> { where(:raw_question => true) }
  def to_s
    name
  end

  def to_text(document, amount_index)
    amount_index -= 1

    if !header_ids.nil?
      _header_ids = header_ids.split('/')
      additional_info = TemplateField.find(_header_ids.first).document_answers.where(:document_id => document.id).order('id')[amount_index].answer
      additional_info += (" #{ TemplateField.find(_header_ids.last).document_answers.where(:document_id => document.id).order('id')[amount_index].answer }" if _header_ids.length > 1)

      text = ''
      text += name.split('<spain/>').first.gsub(/<insert>/, additional_info) if !name.nil?
      text += '<div class="spain">' + name.split('<spain/>').last.gsub(/<insert>/, additional_info) + '</div>'
      text
    else
      to_s
    end
  end

  def to_text_radio(document, amount_index, index_of_radio)
    amount_index -= 1

    if !header_ids.nil?
      _header_ids = header_ids.split('/')
      additional_info = TemplateField.find(_header_ids.first).document_answers.where(:document_id => document.id).order('id')[amount_index].answer
      additional_info += (" #{ TemplateField.find(_header_ids.last).document_answers.where(:document_id => document.id).order('id')[amount_index].answer }" if _header_ids.length > 1)

      text = ''
      array_radio_titles = name.split('<option/>')
      tmp_array = array_radio_titles[index_of_radio].split('<spain/>')
      text += tmp_array.first.gsub(/<insert>/, additional_info) if !name.nil?
      text += '<div class="spain">' + tmp_array.last.gsub(/<insert>/, additional_info) + '</div>'
    else
      to_s
    end
  end
end
