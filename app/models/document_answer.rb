class DocumentAnswer < ActiveRecord::Base

  belongs_to :template_field, -> { includes(:template_step) }
  belongs_to :document

  NUMBER_NAME = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh']

  #validates :answer, :format => { :with => (-> { Regexp.new template_field.mandatory }).call }, :on => :update

  def to_s
    answer
  end
end