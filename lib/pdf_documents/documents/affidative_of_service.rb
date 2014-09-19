module PdfDocument
  class DivorceComplaint < CaseWrapper
    def generate
      _counter = 0
      default_leading 5
      push_text 'COMD', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_addres }"
      push_text "#{ @plaintiff_home_address_city }, #{ @plaintiff_home_address_state } #{ @plaintiff_home_address_zip }"

      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"
      push_text 'Plaintiff Self-Represented', :style => :bold

      move_down 20
      push_header "IN THE #{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT OF THE"
      push_header "STATE OF NEVADA, IN AND FOR THE COUNTY OF #{ @clark_nye.upcase }"
      move_down 20

      default_leading 3
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name },", :inline_format => true
      push_text "Plaintiff,#{ ' '*61 }CASE NO.:"
      move_down 10
      push_text "vs.#{ ' '*71 }DEPT NO.:"
      move_down 10
      push_text "#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name },", :inline_format => true
      push_text 'Defendant.'

      default_leading 8
      move_down 30
      push_header 'COMPLAINT FOR DIVORCE'


      move_down 30
      push_text 'DATED THIS _______day of  ___________, 20___'
      default_leading 0
      push_text 'Submitted by: __________________', 130
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }   Signature", 200

      move_down @header_margin_top
      default_leading 8
      push_header 'VERIFICATION'
      move_down

      push_text 'Under penalties of perjury, I declare that I am the Plaintiff in the above-entitled action; that I have read the foregoing Complaint and know the contents thereof, that the pleading is true of my own knowledge, except for those matters therein contained stated upon information and belief, and that as to those matters, I believe them to be true.', @text_indent

      move_down
      push_text 'I declare under penalty of perjury under the law of the State of Nevada that the foregoing is true and correct.', @text_indent

      move_down
      push_text 'DATED this _______day of  ___________, 20___'
      move_down 30
      default_leading 0
      push_text 'Submitted by: __________________'
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"

      finishing
    end
  end
end













