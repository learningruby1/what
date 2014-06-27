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

      numbers = ''; 28.times do |i| numbers += "\n\n#{ i + 1 }" end
      leading = 8

      Prawn::Document.generate("app/documents/pdf/document_#{ document.id }.pdf") do
        repeat :all do

          font "Times-Roman"
          #Header, invisible
          canvas do
            bounding_box([bounds.left, bounds.top], :width => bounds.width) do
              cell :width => bounds.width, :height => 50, :borders => []
            end
          end
          #Left vertical line with numbers
          canvas do
            bounding_box([bounds.left, bounds.top], :width => 50, :height => bounds.height, :page_filter => :all) do
              cell :width => 50,
                   :height => bounds.height,
                   :borders => [:right],
                   :border_width => 1,
                   :border_color => '858585',
                   #:background_color => '858585'
                   :content => numbers,
                   :align => :right,
                   :text_color => "858585",
                   :padding_top => 50,
                   :size => 10
            end
          end
          #Second left vertical line
          canvas do
            bounding_box([bounds.left + 53, bounds.top], :width => 1, :height => bounds.height) do
              cell :width => 1,
                   :height => bounds.height,
                   :borders => [:left],
                   :border_width => 1
            end
          end
          #Right vertical line
          canvas do
            bounding_box([bounds.right - 50, bounds.top], :width => 1, :height => bounds.height) do
              cell :width => 1,
                   :height => bounds.height,
                   :borders => [:left],
                   :border_color => '858585',
                   :border_width => 1
            end
          end

        end

        #BODY
        bounding_box([bounds.left + 20, bounds.top - 37], :width => 503, :height => bounds.height - 97) do
          cell :width => 503, :height => bounds.height, :borders => [], :padding_left => 5

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
        # footer
        bounding_box [bounds.left, bounds.bottom + 35], :width  => bounds.width do
          number_pages "Page <page> of <total>", { :start_count_at => 0, :page_filter => :all, :align => :center, :size => 12, :color => '858585' }
        end
      end
    end
  end
end