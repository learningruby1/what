module PdfDocument
  class DivorceSummons < DocumentWrapper
    def initialize(document)

      @document_id = document.id
      @data_array = Array.new

      #Step zero
      steps     = document.template.steps.to_enum
      answers   = step_answers_enum steps.next
      clark_nye = answers.next.answer.strip

      #First step   Your information
      answers = step_answers_enum steps.next

      plaintiff_first_name  = answers.next.answer
      plaintiff_middle_name = answers.next.answer
      plaintiff_last_name   = answers.next.answer

      #Second step   Your Spouse\'s Information
      answers = step_answers_enum steps.next

      defendant_first_name  = answers.next.answer
      defendant_middle_name = answers.next.answer
      defendant_last_name   = answers.next.answer

      #Step 3   Marriage Information
      answers = step_answers_enum steps.next

      in_the_us = answers.next.answer == 'In the United States'
      marriage_city = answers.next.answer
      marriage_state = answers.next.answer

      marriage_city_town_province = answers.next.answer
      marriage_country = answers.next.answer
      marriage_date = answers.next.answer

      marriage_country_string = "#{ in_the_us ? marriage_city : marriage_city_town_province }"
      marriage_country_string += in_the_us ? " State of #{ marriage_state }" : " Country of #{ marriage_country }"



      header_margin_top = 40
      text_indent = 20

      push_header "#{ clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT"
      push_header "#{ clark_nye } JUDICIAL DISTRICT COURT"
      move_down 30

      push_text_right 'Case No ______________________'
      move_down
      push_text_right 'Dept. No ______________________'

      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name } Plaintiff,"
      push_text 'vs.'
      push_text "#{ defendant_first_name } #{ defendant_middle_name } #{ defendant_last_name } Defendant"

      push_text '______________________________________________         SUMMONS'
      move_down 15

      push_text 'NOTICE!  YOU HAVE BEEN SUED.  THE COURT MAY DECIDE AGAINST YOU WITHOUT YOUR BEING HEARD UNLESS YOU RESPOND WITHIN 20 DAYS.  READ THE INFORMATION BELOW.'
      move_down
      push_text "TO THE DEFENDANT: #{ defendant_first_name } #{ defendant_middle_name } #{ defendant_last_name }"

      move_down
      push_text 'A civil Complaint for Divorce has been filed by the plaintiff against you; this action is brought to recover a judgment dissolving the bonds of matrimony existing between you and the plaintiff.', text_indent

      move_down
      push_text '1.  If you intend to defend this lawsuit, within 20 days after this Summons is served on you, exclusive of the day of service, you must do the following:', text_indent
      move_down
      push_text 'a.  File with the Clerk of this Court, whose address is shown below, a formal written', text_indent * 2
      push_text 'response to the Complaint in accordance with the rules of the Court.', text_indent * 2 + 18
      push_text 'b. Serve a copy of your response upon the attorney whose name and address is shown', text_indent * 2
      push_text 'below.', text_indent * 2 + 18
      move_down 20
      push_text '2.  Unless you respond, your default will be entered upon application of the plaintiff and this Court may enter a judgment against you for the relief demanded in the Complaint, which could result in the taking of money or property or other relief requested in the Complaint.', text_indent
      move_down
      push_text '3.  If you intend to seek the advice of an attorney in this matter, you should do so promptly so that your response may be filed on time.', text_indent
      move_down 40
      push_text 'Submitted by:                                                          Clerk of the Court'
      move_down 30
      push_text '____________________________                        By: ____________________________'
      move_down 5
      push_text 'Signature                                                                 Deputy Clerk'
      move_down 5
      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name }                                                 #{ marriage_country_string }"

      @data_array_enum = @data_array.to_enum
    end
  end
end