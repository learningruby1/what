module PdfDocument
  class Pdf
    require 'pdf_documents/document_wrapper'
    require 'pdf_documents/documents/divorce_complaint'
    require 'prawn'

    def generate(document)

      case document.template.to_s

      when 'Complaint for Divorce'
        wrapped_document = PdfDocument::DivorceComplaint.new document
      end


      Prawn::Document.generate("app/documents/pdf/document_#{ document.id }.pdf") do

        wrapped_document.amount.times do

          next_element = wrapped_document.next
          next_line = next_element.last
          command   = next_element.first
          command_number = command.split(' ').last.to_i

          case command
          when 'text'
            text next_line, :inline_format => true

          when /^text /
            text next_line, :inline_format => true, :indent_paragraphs => command_number

          when /^header /
            font_size(command_number){ text next_line, :align => :center }

          when /\d/
            move_down command_number

          end
        end
      end
    end
  end
end