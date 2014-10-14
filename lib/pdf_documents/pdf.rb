module PdfDocument
  class Pdf
    require 'pdf_documents/wrapper'
    require 'pdf_documents/divorce_wrapper'
    require 'pdf_documents/documents/divorce_complaint'
    require 'pdf_documents/documents/divorce_summons'
    require 'pdf_documents/documents/divorce_injunction'
    require 'pdf_documents/documents/divorce_cover'
    require 'pdf_documents/documents/divorce_coversheet'
    require 'pdf_documents/documents/affidative_or_acceptance_of_service'
    require 'pdf_documents/documents/uccja'
    require 'prawn'

    def generate(document)
      answer_county = TemplateStep.where(:title => 'In what county are you going to file your case? /<spain/>¿En qué condado va a archivar su caso?').first.document_answers.first

      case document.template.to_s
      when /^Complaint for Divorce/
        generate_document PdfDocument::DivorceComplaint.new(document).generate,  "Divorce_complaint_#{ document.id }", true, true
        generate_document PdfDocument::DivorceSummons.new(document).generate,    "Divorce_summons_#{ document.id }"
        generate_document PdfDocument::DivorceInjunction.new(document).generate, "Divorce_injunction_#{ document.id }"
        generate_document PdfDocument::Uccja.new(document).generate,             "UCCJA_#{ document.id }"
        if answer_county == 'Clark'
          generate_document PdfDocument::DivorceCover.new(document).generate,      "Divorce_cover_#{ document.id }"
        else
          generate_document PdfDocument::DivorceCoversheet.new(document).generate, "Divorce_coversheet_#{ document.id }"
        end
      when /^Filed Case/
        generate_document PdfDocument::AffidativeOrAcceptanceOfService.new(document).generate,      "AffidativeAcceptance_of_service_#{ document.id }"
      end
    end

    def generate_document(wrapped_document, document_name, judical_layout=false, footer_layout=false)

      if judical_layout
        numbers = ''; 28.times do |i| numbers += "\n\n#{ i + 1 }" end
        leading = 8
      end

      Prawn::Document.generate("documents/pdf/#{ document_name }.pdf") do
        font "Times-Roman"

        if !judical_layout
          #default page params
          bound_left = bounds.left
          bound_top = bounds.top + 20
          width = 540
          height = bounds.height + 20
          padding_left = 0

        else
          #page params for judical layout
          bound_left = bounds.left + 20
          bound_top = bounds.top - 37
          width = 503
          height = bounds.height - 97
          padding_left = 5

          repeat :all do
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
        end

        # #BODY
        bounding_box([bound_left, bound_top], :width => width, :height => height) do
          cell :width => width, :height => height, :borders => [], :padding_left => padding_left

          wrapped_document.amount.times do

            next_element = wrapped_document.next
            next_line = next_element.last
            command   = next_element.first
            command_number = command.split(' ').second.to_i rescue nil
            if command.split(' ').length > 2
              additional_command = command.split(' ').last.to_i
            else
              additional_command = -1
            end

            case command
            when 'text'
              text next_line, :inline_format => true
            when /^text-right /
              font_size(command_number){ text next_line, :align => :right }
            when /^text /
              text next_line, :inline_format => true, :indent_paragraphs => command_number
            when /^header /
              font_size(command_number){ text next_line, :align => :center, :inline_format => true }
            when /^table /
              _font_size = additional_command == 0 ? 10 : 8
              table next_line, :width => width, :cell_style => { :inline_format => true, :size => _font_size, :font => "Times-Roman" } do

                cells.style :valign => :top
                cells.style :padding => [3, 0, 4, 3]
                cells.row(0).background_color = 'DFDFDF' if command_number > -1
                cells.row(command_number).background_color = 'DFDFDF' if command_number > 0
              end
            when 'new_page'
              start_new_page
            when /^default_leading/
              default_leading command[command.length - 1].to_i
            when /^rectangle/
              array_tmp = command.split(' ')
              stroke_color '000000'
              stroke_rectangle [array_tmp.second.to_i, array_tmp.last.to_i], 10, 10
            when /^small_rectangle/
              array_tmp = command.split(' ')
              stroke_color '000000'
              stroke_rectangle [array_tmp.second.to_i, array_tmp.last.to_i], 8, 8
            when /^checked_rectangle/
              array_tmp = command.split(' ')
              stroke_color '000000'
              stroke_rectangle [array_tmp.second.to_i, array_tmp.last.to_i], 10, 10
              stroke_line [array_tmp.second.to_i, array_tmp.last.to_i - 5], [array_tmp.second.to_i + 5, array_tmp.last.to_i - 10]
              stroke_line [array_tmp.second.to_i + 5, array_tmp.last.to_i - 10], [array_tmp.second.to_i + 10, array_tmp.last.to_i]
            when /^small_checked_rectangle/
              array_tmp = command.split(' ')
              stroke_color '000000'
              stroke_rectangle [array_tmp.second.to_i, array_tmp.last.to_i], 8, 8
              stroke_line [array_tmp.second.to_i, array_tmp.last.to_i - 4], [array_tmp.second.to_i + 4, array_tmp.last.to_i - 8]
              stroke_line [array_tmp.second.to_i + 4, array_tmp.last.to_i - 8], [array_tmp.second.to_i + 8, array_tmp.last.to_i]
            when /^move_to_left/
              font_size(command_number){ text next_line, :indent_paragraphs => 200, :inline_format => true }
            when /^create_line/
              array_tmp = command.split(' ')
              stroke do
                horizontal_line array_tmp.second.to_i, array_tmp.third.to_i, :at => array_tmp.fourth.to_i
              end
            when /\d/
              move_down next_line.to_i
            end
          end
        end

        if footer_layout
          bounding_box [bounds.left, bounds.bottom + 35], :width  => bounds.width do
            number_pages "www.FormsMama.com                          Page <page> of <total>                    Complaint for divorce #{ Time.now.year }", { :start_count_at => 0, :page_filter => :all, :align => :center, :size => 12, :color => '858585' }
          end
        end
      end
    end
  end
end