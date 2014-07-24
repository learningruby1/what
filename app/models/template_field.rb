class TemplateField < ActiveRecord::Base

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory

  def to_s
    name
  end

  def to_text(document, amount_index)
    amount_index -= 1
    if !header_id.nil?
      additional_info = TemplateField.find(header_id).document_answers.where(:document_id => document.id)[amount_index].answer
      additional_info += (" #{ TemplateField.find(additional_header_id).document_answers.where(:document_id => document.id)[amount_index].answer }" if !additional_header_id.nil?)
      [
        name.split('<spain/>').first,
        '<i>',
        additional_info,
        '</i>',
        ("<div class='spain'>#{ name.split('<spain/>').last } <i>#{ additional_info }</i></div>" if name.split('<spain/>').length > 1)
      ].join ' '
    else
      to_s
    end
  end
end
