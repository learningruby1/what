class Template < ActiveRecord::Base

  has_many :fields, :class_name => 'TemplateField'
  has_many :documents

  def to_s
    name
  end

  def to_desc
    description
  end
end
