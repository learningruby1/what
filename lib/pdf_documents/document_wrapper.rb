module PdfDocument
  class DocumentWrapper

    def next
      @data_array_enum.next
    end

    def amount
      @data_array.try(:length).to_i || 0
    end

    protected
    def step_answers_enum(step, loop_step=0)
      step.fields.map{ |f| f.document_answers.where(:document_id => @document_id).order('id')[loop_step] }.reverse.to_enum
    end

    def step_answers_looped_enum(step)
      step.fields.map{ |f| f.document_answers.where(:document_id => @document_id) }.reverse.to_enum
    end

    def push_text(text, indent=0)
      if indent == 0
        @data_array.push ['text', text]
      else
        @data_array.push ["text #{ indent.to_s }", text]
      end
    end

    def push_text_right(text, size=10)
      @data_array.push ["text-right #{ size.to_s }", text]
    end

    def push_header(text, size=13)
      @data_array.push ["header #{ size.to_s }", text]
    end

    def move_down(number=10)
      @data_array.push [number.to_s]
    end

    def get_headed_info(answer, amount_index)
      _header_ids = answer.template_field.header_ids.split('/')
      additional_info = TemplateField.find(_header_ids.first).document_answers.where(:document_id => @document_id)[amount_index].answer
      additional_info += (" #{ TemplateField.find(_header_ids.last).document_answers.where(:document_id => @document_id)[amount_index].answer }" if _header_ids.length > 1)

      additional_info
    end
  end
end