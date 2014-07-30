class TemplateField < ActiveRecord::Base

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory

  def to_s
    name
  end

  def to_text(document, amount_index)
    amount_index -= 1

    if !header_ids.nil?
      _header_ids = header_ids.split('/')
      additional_info = TemplateField.find(_header_ids.first).document_answers.where(:document_id => document.id)[amount_index].answer
      additional_info += (" #{ TemplateField.find(_header_ids.last).document_answers.where(:document_id => document.id)[amount_index].answer }" if _header_ids.length > 1)

      text = ''
      text += name.split('<spain/>').first if !name.nil?
      text += '<i>' + additional_info + '</i>'
      text += '<div class="spain">' + name.split('<spain/>').last + '<i>' + additional_info + '</i>' + '</div>' if !name.nil? && name.split('<spain/>').length > 1
      text
    else
      to_s
    end
  end
end
