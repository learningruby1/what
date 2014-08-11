class TemplateStep < ActiveRecord::Base

  has_many :fields, :class_name => 'TemplateField'
  has_many :render_fields,  :class_name => 'DocumentAnswer',:primary_key => 'render_if_field_id', :foreign_key => 'template_field_id'
  has_many :amount_fields,    :class_name => 'DocumentAnswer', :primary_key => 'amount_field_id', :foreign_key => 'template_field_id'
  has_many :amount_answer_if, :class_name => 'DocumentAnswer', :primary_key => 'amount_field_if', :foreign_key => 'template_field_id'

  def to_question_title
    [title].join('. ')
  end

  def to_s
    title
  end

  def to_i
    step_number.to_i
  end

  def amount_if_answer(document)
    amount_answer_if.this_document(document).first.answer rescue nil
  end

  def to_description(document)
    insert = description.match(/<insert id=\d+\/>/)[0] rescue nil
    return description if insert.nil?
    replace_data = TemplateField.find(insert.match(/\d+/)[0]).document_answers.where(:document_id => document.id).first.answer
    description.sub(insert, replace_data).sub(insert, replace_data)
  end
end
