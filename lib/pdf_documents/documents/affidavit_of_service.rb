module PdfDocument
  class AffidavitOfService < DivorceWrapper
    def can_generate?
      @person_who_give =~ /I have a friend/
    end

    def generate
      _counter = 0
      default_leading 2
      push_text 'AFFT', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_addres }"
      push_text "#{ @plaintiff_home_address_city }, #{ @plaintiff_home_address_state } #{ @plaintiff_home_address_zip }"

      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"
      push_text 'Self-Represented', :style => :bold

      move_down 20
      push_header "IN THE #{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT OF THE"
      push_header "STATE OF NEVADA, IN AND FOR THE COUNTY OF #{ @clark_nye.upcase }"
      move_down 20


      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }<br/>Plaintiff,<br/><br/>vs.<br/><br/>#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name }<br/>Defendant.", :width => 300, :font_style => :bold },
                  { :content => "<br/>CASE  NO.: #{@case.to_s}<br/><br/><br/>DEPT NO.: #{@dept.to_s}", :width => 240 } ]
      push_table -1, 0

      default_leading 8
      move_down 20
      push_header 'AFFIDAVIT OF SERVICE'
      move_down 20
      default_leading 0
      push_text "STATE OF #{'_'*20}"
      push_text 'ss:', 170
      push_text "COUNTY OF #{'_'*18}"
      move_down

      push_text "#{@friend_first_name} #{@friend_middle_name} #{@friend_last_name}, the Affiant being duly sworn, states that at all times herein Affiant was and is over 18 years of age, not a party to nor interested in the proceeding in which this affidavit is made."

      push_text "That Affiant has a #{@friend_radio_address} address of #{@friend_home_address} #{@friend_home_address_city}, #{@friend_home_address_zip}.", @text_indent

      push_text "That Affiant’s phone number is #{@friend_phone}.", @text_indent

      push_text 'That Affiant is not required to be a licensed process server because Affiant is not engaged in business as a process server as defined in NRS 648.014.', @text_indent

      push_text "That Affiant received a copy of the Summons and Complaint on the #{@summons_and_complaint_date.split("/")[0]} day of #{@summons_and_complaint_date.split("/")[1]}, #{@summons_and_complaint_date.split("/")[2]}.", @text_indent
      if @preliminary_injunction_date_present
        push_text "That Affiant received a copy of the Preliminary Injunction on the #{@preliminary_injunction_date.split("/")[0]} day of #{@preliminary_injunction_date.split("/")[1]}, #{@preliminary_injunction_date.split("/")[2]}.", @text_indent if @preliminary_injunction_date_present
      end
      push_text "That Affiant personally served (insert Plaintiff or Defendant) with a copy of the above stated documents on the (insert date) day (insert Month), (insert year) at about (insert time  a.m. or p.m.) by:", @text_indent


      move_down 20
      default_leading 0
      table_row [ { :content => "<br/><br/><br/><br/><br/>", :width => 300, :font_style => :bold, :border_width => 0  },
                  { :content => "<br/>#{'_'*40}<br/>Signature of Affiant<br/>#{@friend_first_name} #{@friend_middle_name} #{@friend_last_name}", :width => 240, :border_width => 0  } ]
      push_table -1, 0

      move_down
      push_text 'SUSCRIBED and SWORN to before me this'
      push_text '_______day of ___________, 20___.'
      push_text "By #{@friend_first_name} #{@friend_middle_name} #{@friend_last_name}"
      move_down 20
      default_leading 014
      push_text '______________________'
      push_text 'NOTARY PUBLIC'

      finishing
    end
  end
end