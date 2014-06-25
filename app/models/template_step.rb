class TemplateStep < ActiveRecord::Base

  has_many :fields, :class_name => 'TemplateField'
  has_many :render_fields, :class_name => 'DocumentAnswer', :primary_key => 'render_if_field_id', :foreign_key => 'template_field_id'
  has_many :amount_fields, :class_name => 'DocumentAnswer', :primary_key => 'amount_field_id', :foreign_key => 'template_field_id'

  def to_question_title
    [title].join('. ')
  end

  def to_s
    title
  end

  def to_i
    step_number.to_i
  end
end
