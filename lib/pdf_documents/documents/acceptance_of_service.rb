module PdfDocument
  class AcceptanceOfService < DivorceWrapper
    def can_generate?
      @filed_case[:person_who_give] =~ /accept/
    end

    def generate
      _counter = 0
      default_leading 2
      push_text 'ACSR', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_addres }"
      push_text "#{ @plaintiff_home_address_city }, #{ @plaintiff_home_address_state } #{ @plaintiff_home_address_zip }"

      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"
      push_text 'Self-Represented', :style => :bold

      move_down 40
      push_header "IN THE #{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT OF THE"
      push_header "STATE OF NEVADA, IN AND FOR THE COUNTY OF #{ @clark_nye.upcase }"
      move_down 20


      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }<br/>Plaintiff,<br/><br/>vs.<br/><br/>#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name }<br/>Defendant.", :width => 300, :font_style => :bold },
                  { :content => "<br/>CASE  NO.: #{ @filed_case[:case] }<br/><br/><br/>DEPT NO.: #{ @filed_case[:dept] }", :width => 240 } ]
      push_table -1, 0

      default_leading 8
      move_down 20
      push_text ' '
      push_text ' '
      push_header 'ACCEPTANCE OF SERVICE'
      move_down 15
      push_text "I, #{@defendant_first_name} #{@defendant_middle_name} #{@defendant_last_name}, the Defendant in the above stated action accept service of #{'SUMMONS, COMPLAINT'}#{ ', JOINT PRELIMINARY INJUCTION' if @filed_case[:preliminary_injunction_date].present? }."

      move_down 40
      push_text 'DATED this_______day of ___________, 20___.'

      move_down 30
      default_leading 0
      table_row [ { :content => "<br/><br/><br/><br/><br/>", :width => 300, :font_style => :bold, :border_width => 0  },
                  { :content => "<br/>#{'_'*40}<br/>Signature<br/><br/><br/>#{'_'*40}<br/>#{@defendant_first_name} #{@defendant_middle_name} #{@defendant_last_name}", :width => 240, :border_width => 0  } ]
      push_table -1, 0

      finishing
    end
  end
end