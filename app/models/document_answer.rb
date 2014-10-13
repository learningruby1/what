class DocumentAnswer < ActiveRecord::Base
  include DivorceComplaintHelper

  belongs_to :template_field, -> { includes(:template_step) }
  belongs_to :document
  belongs_to :template_step

  scope :this_document, -> (document){ where(:document_id => document.id) }

  NUMBER_NAME = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh']
  STATES = [['', ''],
            ['Alabama', 'AL'],
            ['Alaska', 'AK'],
            ['Arizona', 'AZ'],
            ['Arkansas', 'AR'],
            ['California', 'CA'],
            ['Colorado', 'CO'],
            ['Connecticut', 'CT'],
            ['Delaware', 'DE'],
            ['Florida', 'FL'],
            ['Georgia', 'GA'],
            ['Hawaii', 'HI'],
            ['Idaho', 'ID'],
            ['Illinois', 'IL'],
            ['Indiana', 'IN'],
            ['Iowa', 'IA'],
            ['Kansas', 'KS'],
            ['Kentucky', 'KY'],
            ['Louisiana', 'LA'],
            ['Maine', 'ME'],
            ['Maryland', 'MD'],
            ['Massachusetts', 'MA'],
            ['Michigan', 'MI'],
            ['Minnesota', 'MN'],
            ['Mississippi', 'MS'],
            ['Missouri', 'MO'],
            ['Montana', 'MT'],
            ['Nebraska', 'NE'],
            ['Nevada', 'NV'],
            ['New Hampshire', 'NH'],
            ['New Jersey', 'NJ'],
            ['New Mexico', 'NM'],
            ['New York', 'NY'],
            ['North Carolina', 'NC'],
            ['North Dakota', 'ND'],
            ['Ohio', 'OH'],
            ['Oklahoma', 'OK'],
            ['Oregon', 'OR'],
            ['Pennsylvania', 'PA'],
            ['Rhode Island', 'RI'],
            ['South Carolina', 'SC'],
            ['South Dakota', 'SD'],
            ['Tennessee', 'TN'],
            ['Texas', 'TX'],
            ['Utah', 'UT'],
            ['Vermont', 'VT'],
            ['Virginia', 'VA'],
            ['Washington', 'WA'],
            ['West Virginia', 'WV'],
            ['Wisconsin', 'WI'],
            ['Wyoming', 'WY']]

  PERSON = [['', ''],
            ['Grandma / Abuela', 'Grandma'],
            ['Grandpa / Abuelo', 'Grandpa'],
            ['Aunt / Tía', 'Aunt'],
            ['Uncle / Tío', 'Uncle'],
            ['Cousin / Primo', 'Cousin'],
            ['Friend / Amigo', 'Friend'],
            ['Godparent / Madrina/Padrino', 'Godparent'],
            ['Stepfather / Padrastro', 'Stepfather'],
            ['Stepmother / Madrastra', 'Stepmother'],
            ['Sister / Hermana', 'Sister'],
            ['Brother / Hermano', 'Brother'],
            ['Other / Otro', 'Other']]

  def to_s
    if answer.present? && document.to_s == Document::DIVORCE_COMPLAINT
      answer.gsub! '<child_count>',           number_of_child(document) == '1' ? 'child' : 'children'
      answer.gsub! '<child_count_spain>',     number_of_child(document) == '1' ? 'el menor '  : 'los menores'
      answer[0] = 'C' if answer[0] == 'c'
    end
    answer
  end

  def to_html_array(amount_index=1)
    [(template_field.to_text(document, amount_index).gsub(/<option\/>/, '<br/>') rescue ''),
     to_s]
  end

  def self.sort _answers, step
    if step == '49'
      _answers.sort_by!{ |item| [item.sort_index ? 1 : 0, item.sort_index, item.sort_number, item.template_field_id] }
    else
      _answers.sort_by!{ |item| [item.toggler_offset, item.sort_index ? 1 : 0, item.sort_index, item.sort_number, item.template_field_id] }
    end
  end
end