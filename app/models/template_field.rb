class TemplateField < ActiveRecord::Base

  belongs_to :template_step
  has_many :document_answers
  serialize :mandatory

  def to_s
    name
  end
end
