class DependentDocument < ActiveRecord::Base
  belongs_to :document
  belongs_to :sub_document, :class_name => 'Document', :foreign_key => 'sub_document_id'

  validates_uniqueness_of :sub_document
end
