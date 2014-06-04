class TemplateStep < ActiveRecord::Base

  has_many :fields, :class_name => 'TemplateField'

  def to_question_title
    [step_number, title].join('. ')
  end

  def to_i
    step_number.to_i
  end
end
