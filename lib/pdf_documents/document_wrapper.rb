module PdfDocument
  class DocumentWrapper

    def next
      @data_array_enum.next
    end

    def amount
      @data_array.length
    end

    protected
    def step_answers_enum(step, loop_step=0)
      step.fields.map{ |f| f.document_answers.where(:document_id => @document_id)[loop_step] }.reverse.to_enum
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

    def push_header(text, size=13)
      @data_array.push ["header #{ size.to_s }", text]
    end

    def move_down(number=10)
      @data_array.push [number.to_s]
    end

    def get_headed_info(answer, amount_index)
      additional_info = TemplateField.find(answer.template_field.header_id).document_answers.where(:document_id => @document_id)[amount_index].answer
      additional_info += (" #{ TemplateField.find(answer.template_field.additional_header_id).document_answers.where(:document_id => @document_id)[amount_index].answer }" if !answer.template_field.additional_header_id.nil?)

      additional_info
    end
  end
end