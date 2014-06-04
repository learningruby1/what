class Template < ActiveRecord::Base

  has_many :documents
  has_many :steps, :class_name => 'TemplateStep'

  def to_s
    name
  end

  def to_desc
    description
  end
end
