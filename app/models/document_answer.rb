class DocumentAnswer < ActiveRecord::Base

  belongs_to :template_field, -> { includes(:template_step) }
  belongs_to :document

  NUMBER_NAME = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh']
end
