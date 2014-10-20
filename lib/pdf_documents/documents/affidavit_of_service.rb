module PdfDocument
  class AffidavitOfService < DivorceWrapper
    def can_generate?
      @filed_case[:person_who_give] =~ /I have a friend/
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


      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }\nPlaintiff,\n\nvs.\n\n#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name }\nDefendant.", :width => 300, :font_style => :bold },
                  { :content => "\nCASE  NO.: #{ @filed_case[:case] }\n\n\nDEPT NO.: #{ @filed_case[:dept] }", :width => 240 } ]
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

      push_text "#{ @filed_case[:friend][:full_name] }, the Affiant being duly sworn, states that at all times herein Affiant was and is over 18 years of age, not a party to nor interested in the proceeding in which this affidavit is made."

      push_text "That Affiant has a #{ @filed_case[:friend][:address_type] } address of #{ @filed_case[:friend][:address] } #{ @filed_case[:friend][:city] }, #{ @filed_case[:friend][:zip] }.", @text_indent

      push_text "That Affiant’s phone number is #{ @filed_case[:friend][:phone] }.", @text_indent

      push_text 'That Affiant is not required to be a licensed process server because Affiant is not engaged in business as a process server as defined in NRS 648.014.', @text_indent

      push_text "That Affiant received a copy of the Summons and Complaint on the #{@filed_case[:summons_and_complaint_date].split("/")[0]} day of #{@filed_case[:summons_and_complaint_date].split("/")[1]}, #{@filed_case[:summons_and_complaint_date].split("/")[2]}.", @text_indent

      push_text "That Affiant received a copy of the Preliminary Injunction on the #{@filed_case[:preliminary_injunction_date].split("/")[0]} day of #{@filed_case[:preliminary_injunction_date].split("/")[1]}, #{@filed_case[:preliminary_injunction_date].split("/")[2]}.", @text_indent if @filed_case[:preliminary_injunction_date].present?

      push_text "That Affiant personally served (insert Plaintiff or Defendant) with a copy of the above stated documents on the (insert date) day (insert Month), (insert year) at about (insert time  a.m. or p.m.) by:", @text_indent


      move_down 20
      default_leading 0
      table_row [ { :content => '', :width => 300, :font_style => :bold, :border_width => 0  },
                  { :content => "\n #{'_'*40} \n Signature of Affiant \n #{ @filed_case[:friend][:full_name] }", :width => 240, :border_width => 0  } ]
      push_table -1, 0

      move_down
      push_text 'SUBSCRIBED and SWORN to before me this'
      push_text '_______day of ___________, 20___.'
      push_text "By #{ @filed_case[:friend][:full_name] }"
      move_down 20
      default_leading 014
      push_text '______________________'
      push_text 'NOTARY PUBLIC'

      finishing
    end
  end
end