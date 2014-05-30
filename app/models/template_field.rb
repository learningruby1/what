class TemplateField < ActiveRecord::Base

  has_many :answers, :class_name => 'DocumentAnswer', :foreign_key => 'canonical_name', :primary_key => 'canonical_name'

  def to_s
    name
  end
end
