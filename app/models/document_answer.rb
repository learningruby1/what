class DocumentAnswer < ActiveRecord::Base

  belongs_to :template_field, -> { includes(:template_step) }
  belongs_to :document
end
