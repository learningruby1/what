module PdfDocument
  class DivorceComplaint < DocumentWrapper

    def initialize(document)

      @document_id = document.id
      @data_array = Array.new

      #Step zero
      steps = document.template.steps.to_enum
      answers = step_answers_enum steps.next

      clark_nye = answers.next.answer.strip

      #First step   Your information
      answers = step_answers_enum steps.next

      plaintiff_first_name = answers.next.answer
      plaintiff_middle_name = answers.next.answer
      plaintiff_last_name = answers.next.answer

      plaintiff_date_of_birth = answers.next.answer
      plaintiff_social_security = answers.next.answer
      plaintiff_email = answers.next.answer

      plaintiff_city = answers.next.answer
      plaintiff_state = answers.next.answer
      plaintiff_zip = answers.next.answer

      plaintiff_phone = answers.next.answer
      answers.next
      plaintiff_wife_husband = answers.next.answer

      if plaintiff_wife_husband == 'I am Wife'

        mom = 'plaintiff'
        dad = 'defendant'
      else

        dad = 'plaintiff'
        mom = 'defendant'
      end

      #Second step   Your Spouse\'s Information
      answers = step_answers_enum steps.next

      defendant_first_name = answers.next.answer
      defendant_middle_name = answers.next.answer
      defendant_last_name = answers.next.answer

      defendant_date_of_birth = answers.next.answer
      defendant_social_security = answers.next.answer
      defendant_mailing = answers.next.answer

      defendant_city = answers.next.answer
      defendant_state = answers.next.answer
      defendant_zip = answers.next.answer

      defendant_email = answers.next.answer
      defendant_phone = answers.next.answer

      #Step 3   Marriage Information
      answers = step_answers_enum steps.next

      in_the_us = answers.next.answer == 'In the United States'
      marriage_city = answers.next.answer
      marriage_state = answers.next.answer

      marriage_city_town_province = answers.next.answer
      marriage_country = answers.next.answer
      marriage_date = answers.next.answer

      marriage_country_string = "in the city of #{ in_the_us ? marriage_city : marriage_city_town_province }"
      marriage_country_string += in_the_us ? " State of #{ marriage_state }" : " Country of #{ marriage_country }"
      marriage_country_string += ' and have since remained husband and wife.'

      #Step 4   Nevada Residency
      answers = step_answers_enum steps.next

      lived_in_nevada_since = answers.next.answer

      #Step 5   Pregnacy
      answers = step_answers_enum steps.next
      wife_pregnacy = answers.next.answer == 'IS currently pregnant.'

      #Step 6   Children
      answers = step_answers_enum steps.next
      children_adopted = answers.next.answer == 'Yes' rescue false
      children_residency = false
      #NOTICE: 7 merged with 6
      #Step 7   Children's Residency
      answers.next
      children_residency = answers.next.answer == 'Yes' rescue false

      if !children_residency

        11.times do steps.next end
      else

        #Step 8   Number of children
        answers = step_answers_enum steps.next
        answers.next.answer
        number_of_children = answers.next.answer.to_i

        #Step 9   Child(ren)'s Information
        step = steps.next
        children_info = Array.new

        number_of_children.times do |i|

          answers = step_answers_enum step, i
          child_info = Hash.new
          child_info[:first_name] = answers.next.answer
          child_info[:middle_name] = answers.next.answer
          child_info[:last_name] = answers.next.answer
          child_info[:date_of_birth] = answers.next.answer
          child_info[:social_security] = answers.next.answer
          child_info[:is_son] = answers.next.answer == 'Son'

          children_info.push child_info
        end

        #Step 10   Legal Custody
        answers = step_answers_enum steps.next
        legal_custody_parent = answers.next.answer

        #Step 11   Physical Custody
        answers = step_answers_enum steps.next

        answers.next
        physical_custody_parent = answers.next.answer

        #Step 12   Holiday
        answers = step_answers_enum steps.next

        holiday_counter = 0

        holidays = Array.new
        7.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end

        #Father and mother days, havent who
        4.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end


        #Step 13   More holiday
        answers = step_answers_enum steps.next

        10.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end

        #Father and mother days, havent who
        2.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end

        3.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end

        #Holidays have no time
        3.times do
          holiday = Array.new
          holiday.push answers.next
          holiday.push answers.next.answer
          holiday.push answers.next.answer
          holiday.push answers.next.answer

          holiday_counter += 1 if holiday[0].answer == '1'
          holidays.push holiday
        end

        holiday = Array.new

        holiday.push answers.next
        holiday.push answers.next.answer
        holiday.push answers.next.answer
        holiday.push answers.next.answer
        holiday.push answers.next.answer

        holiday_counter += 1 if holiday[0].answer == '1'
        holidays.push holiday

        #Step 14   Children’s Health Insurance
        answers = step_answers_enum steps.next
        child_insurance = answers.next.answer

        #Step 15   Child Support
        answers = step_answers_enum steps.next
        child_suport_who = answers.next.answer
        child_suport_amount = answers.next.answer

        #Step 16   Wage withholding
        answers = step_answers_enum steps.next
        answers.next.answer
        request_withhold = answers.next.answer == 'Yes' rescue false

        #Step 17   Child  Support Arrears
        answers = step_answers_enum steps.next
        answers.next
        answers.next
        request_arrears = answers.next.answer == 'Yes' rescue false
        request_arrears_from = answers.next.answer
        answers.next
        request_amount_paid = answers.next.answer

        #Step 18   Child Tax Exemption
        answers = step_answers_enum steps.next
        tax_examption_who = answers.next.answer
        tax_examption_date = answers.next.answer
      end

      #Step 19   Pet
      answers = step_answers_enum steps.next
      pet_presence = answers.next.answer == 'Yes' rescue false
      pet_amount = answers.next.answer.to_i rescue 0

      if !pet_presence

        steps.next
      else

        #Step 20   Pet custody
        step = steps.next

        pets = Array.new
        pet_amount.times do |i|

          answers = step_answers_enum step, i
          pet = Array.new

          pet.push answers.next.answer
          pet.push answers.next.answer
          pets.push pet
        end
      end

      #Step 21   Property
      answers = step_answers_enum steps.next
      answers.next
      property_presence = answers.next.answer

      if property_presence != 'Yes'

        8.times do steps.next end
      else

        #Step 22   Property Division: Marital Home
        answers = step_answers_enum steps.next
        property_marital_presence = answers.next.answer == 'Yes'
        property_marital_address = answers.next.answer
        property_marital_who = answers.next.answer
        answers.next
        property_presence_more = answers.next.answer == 'Yes'

        properties_more = Array.new
        property_count = 0

        #Step 23   Property Division: Marital Home
        answers = step_answers_looped_enum steps.next
        if property_presence_more

          answers.first.length.times do
            properties_more.push Array.new
          end

          answers.each do |answer|
            answer.each_with_index do |a, i|

              properties_more[i].push a
            end
          end
          property_count = properties_more.length
        end

        #Step 24   Property Division: Vehicles
        answers = step_answers_enum steps.next
        vehicles_presence = answers.next.answer == 'Yes' rescue false

        #Step 25   Property Division: Vehicles
        answers = step_answers_looped_enum steps.next
        if vehicles_presence

          answers.first.length.times do
            properties_more.push Array.new
          end

          answers.each do |answer|
            answer.each_with_index do |a, i|

              properties_more[i + property_count].push a
            end
          end
          property_count = properties_more.length
        end

        #Step 26   Property Division: Pension Benefit
        answers = step_answers_looped_enum steps.next

        debts_accounts = Array.new
        answers.first.length.times do
          debts_accounts.push Array.new
        end

        answers.each do |answer|
          answer.each_with_index do |a, i|

            debts_accounts[i].push a
          end
        end
        #Step 27   Property Division: Bank and Investment Account
        answers = step_answers_looped_enum steps.next

        bank_account = Array.new
        answers.first.length.times do
          bank_account.push Array.new
        end

        answers.each do |answer|
          answer.each_with_index do |a, i|

            bank_account[i].push a
          end
        end

        #Step 28   Property Division: Other
        answers = step_answers_enum steps.next
        other_property_presence = answers.next.answer == 'Yes' rescue false

        #Step 29   Property Division: Other
        answers = step_answers_enum steps.next
        if other_property_presence

          other_properties = Array.new
          answers.each do |answer|
            other_properties.push answer.template_field.to_s.split(' /<spain/>').first if answer.answer == '1'
          end
        end

      end

      #Step 30   Debts
      answers = step_answers_looped_enum steps.next
      5.times do steps.next end




      #Step 36   Spousal support or Alimony
      answers = step_answers_enum steps.next
      alimony_presence = answers.next.answer == 'Yes' rescue false
      if alimony_presence

        alimony_who = answers.next.answer
        alimony_how_much = answers.next.answer
        alimony_how_long = answers.next.answer
        alimony_year_month = answers.next.answer
      end

      #Step 37   Wife’s Name
      answers = step_answers_enum steps.next
      wife_name_changing = answers.next.answer
      wife_name = answers.next.answer

      #Step 38   Reason divorce
      answers = step_answers_enum steps.next
      reason_divorce = answers.next.answer

      header_margin_top = 60
      text_indent = 20

      push_text 'COMD', :style => :bold
      move_down

      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name }"
      move_down
      push_text "#{ plaintiff_city } #{ plaintiff_state } #{ plaintiff_zip }"
      push_text "#{ plaintiff_phone }"
      push_text "#{ plaintiff_email }"

      move_down
      push_text 'Plaintiff In Proper Person', :style => :bold

      move_down 20
      push_header "#{ clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT"
      push_header "#{ clark_nye } JUDICIAL DISTRICT COURT"
      move_down 20

      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name } Plaintiff,", :inline_format => true
      push_text 'vs.'
      push_text "#{ defendant_first_name } #{ defendant_middle_name } #{ defendant_last_name } Defendant", :inline_format => true

      move_down 30
      push_header 'COMPLAINT FOR DIVORCE'
      move_down

      push_text "COMES NOW Plaintiff, #{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name }, in Proper Person, and files this Complaint for Divorce against the above Defendant, and alleges as follows:", text_indent

      move_down header_margin_top
      push_header '1. RESIDENCY'
      move_down

      push_text "That the Plaintiff  has been and continues to be an actual, bona fide resident of the #{ clark_nye } County,  Nevada and has been actually physically present and domiciled in the State of Nevada for more than six (6) weeks prior to the filing of this action.", text_indent

      move_down header_margin_top
      push_header '2. DATE OF MARRIAGE'
      move_down

      push_text "That the parties were married on the #{ marriage_date } #{ marriage_country_string }", text_indent

      move_down header_margin_top
      move_down header_margin_top
      push_header '3. MINOR CHILDREN'
      move_down

      if children_residency
        push_text "That the parties have #{ number_of_children } minor #{ number_of_children > 1 ? 'children' : 'child' } to wit:", text_indent

        children_info.each do |c|
          move_down
          push_text "#{ c[:first_name] } #{ c[:middle_name] } #{ c[:last_name] } born #{ c[:date_of_birth] }, security # #{ c[:social_security] }, #{ c[:is_son] ? 'son' : 'daughter' }", text_indent
          move_down
        end

        push_text "That the minor #{ number_of_children > 1 ? 'children are' : 'child is' } residents of the State of  Nevada and #{ number_of_children > 1 ? 'have' : 'has' } lived in this state for at least the past six (6) months.", text_indent
      elsif children_adopted
        push_text "That the minor children are not residents of the State of Nevada and have not lived in this state for at least the past six (6) months.", text_indent
      else
        push_text 'That the parties do not have minor children who are the issue of this marriage or were adopted.', text_indent
      end

      move_down header_margin_top
      push_header '4. PREGNACY'
      move_down

      push_text "That the wife in this case #{ wife_pregnacy ? 'is' : 'not' } currently pregnant.", text_indent


      if children_adopted && children_residency

        move_down header_margin_top
        push_header '5. LEGAL CUSTODY'
        move_down

        case legal_custody_parent
        when 'Both Parents'
          push_text "That both parties are fit and proper people to be awarded JOINT LEGAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' }.", text_indent
        when 'Only MOM'
          push_text "#{ mom.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' }", text_indent
        when 'Only DAD'
          push_text "#{ dad.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' }", text_indent
        end

        move_down header_margin_top
        push_header '6. PHYSICAL CUSTODY'
        move_down

        case physical_custody_parent
        when /^With mom/
          push_text "That #{ mom } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' } with dad having visitation as follows: (insert the proposed visitation schedule)", text_indent
        when /^With dad/
          push_text "That #{ dad } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' } with mom having visitation as follows: (insert the proposed visitation schedule)", text_indent
        when /^Both/
          push_text "That the parties are fit and proper person to be awarded JOINT PHYSICAL custody of the minor #{ number_of_children > 1 ? 'children' : 'child' } and the parties’ timeshare should be as follows: (insert the proposed timeshare)", text_indent
        end

        move_down header_margin_top
        push_header '7. HOLIDAYS VISITATION'
        move_down

        if holiday_counter > 0
          push_text 'That the parties should follow the following Holiday schedule:'
          holidays.each do |holiday|
            if holiday[0].answer == '1'
              holiday_string = holiday[0].template_field.name.split(' /<spain/>').first
              case holiday.count
              when 3
                holiday_string += ": from #{ holiday[1] } to #{ holiday[2] }"
              when 4
                holiday_string += ": #{ holiday[1] } with #{ holiday[2] }, #{ holiday[3] }"
              when 5
                holiday_string += ": from #{ holiday[1] } to #{ holiday[2] } with #{ holiday[3] }, #{ holiday[4] }"
              end
              push_text holiday_string
            end
          end
        else
          push_text 'That the parties should not follow a specific Holiday schedule.'
        end

        move_down header_margin_top
        push_header '8. CHILD INSURANCE'
        move_down

        case child_insurance
        when /^Both/
          push_text "That both parties should both maintain medical and dental insurance for the minor #{ number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule."
        else
          push_text "That #{ child_insurance == 'Dad' ? dad : mom } should maintain medical and dental insurance for the minor #{ number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule."
        end

        move_down header_margin_top
        push_header '9. CHILD SUPPORT'
        move_down

        case child_suport_who
        when /^No/
          push_text child_suport_who
        when /^Dad|^Mom/
          push_text "That #{ child_suport_who == 'Dad will pay $' ? dad : mom } should pay $ #{ child_suport_amount } per month for support of the parties' minor #{ number_of_children > 1 ? 'children' : 'child' }. This amount is in compliance with NRS 125B.070. The obligation to pay child support should continue until the #{ number_of_children > 1 ? 'children' : 'child' } #{ number_of_children > 1 ? 'reaches' : 'reach' } the age of 18 and no longer in high school, or 19 years of age, whichever occurs first, or emancipates.", text_indent
        end

        move_down header_margin_top
        push_header '10. WAGE WITHHOLDING'
        move_down

        if request_withhold
          push_text 'That a wage withholding order be issued against the obligor parent to secure payment of child support and spousal support, if any.'
        else
          push_text 'That Plaintiff is not asking for wage withholding.'
        end

        move_down header_margin_top
        push_header '11. CHILD SUPPORT ARREARS'
        move_down

        if request_arrears
          push_text "That Plaintiff should be awarded back child support from #{ request_arrears_from }, which is when the parties separated and Plaintiff become the custodial parent, Plaintiff asks that this award be reduced to judgment and collectable by any legal means."
        else
          push_text 'The Plaintiff is not asking for back child support and waives Plaintiff’s rights to child support arrears.'
        end

        move_down header_margin_top
        push_header '12. TAX DEDUCTION / EXEMPTIONS'
        move_down

        case tax_examption_who
        when /^Mom every|^Dad every/
          push_text "That #{ tax_examption_who } should claim the minor #{ number_of_children > 1 ? 'children' : 'child' }. as #{ number_of_children > 1 ? 'dependents' : 'dependent' } for Federal Tax purposes every year."
        when /^Dad and Mom/
          push_text "That the parties should alternate claiming the minor #{ number_of_children > 1 ? 'children' : 'child' }. as dependent(s) for Federal Tax purposes."
        end

      # End of children
      end

      move_down header_margin_top
      push_header '13. COMMUNITY PROPERTY'
      move_down

      case property_presence
      when 'Yes'
        push_text 'That there are community debts which should be divided by the Court as follows:', text_indent
        move_down

        if property_marital_presence

          push_text "Marital home: #{ property_marital_address }, #{ property_marital_who }", text_indent
        end

        properties_more.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i != 1 && i % 3 == 0
              push_text property_string, text_indent if property_string != '' || property_string != ','
              property_string = p.answer == '1' ? p.template_field.name.split(' /<spain/>').first : ''
            else
              property_string += ", #{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end


        move_down
        if other_property_presence

          push_text 'Plaintiff wants to keep next properties:', text_indent
          other_properties.each do |other_property|
            push_text "#{ other_property }", text_indent
          end
        end

        move_down
        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', text_indent

        move_down header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down

        push_text 'That there are community debts which should be divided by the Court as follows:', text_indent
        #push_text 'To the Plaintiff:',
        #  20
        move_down

        debts_accounts.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i % 2 == 0
              push_text property_string + ", #{ p.answer }", text_indent if property_string != '' && property_string != ', Yes'
              property_string = p.answer == 'Yes' ? p.template_field.template_step.to_s.split(' /<spain/>').first.split(': ').last.strip : ''
            else
              property_string += ', ' if property_string.length > 0
              property_string += "#{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end

        bank_account.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i % 4 == 0
              push_text property_string + ", #{ p.answer }", text_indent if property_string != '' && property_string != ', Yes'
              property_string = p.answer == 'Yes' ? p.template_field.template_step.to_s.split('<br/><spain/>').first.split(': ').last.strip : ''
            else
              property_string += ', ' if property_string.length > 0
              property_string += "#{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end

        move_down
        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', text_indent

      when 'No, we already divided them'
        push_text 'That the parties have already made an equal distribution of their community property.', text_indent

        move_down header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down
        push_text 'That the parties have already equally divided their existing community debts.'
      else # Means 'No'
        push_text ' That there is no community property which should be divided by the Court. Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', text_indent

        move_down header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down
        push_text 'There are no community debts which should be divided by the court. Plaintiff ask for leave to amend the Complaint once other debts are discovered and identified'
      end

      move_down header_margin_top
      push_header '15. SPOUSAL SUPPORT'
      move_down

      if alimony_presence
        push_text "That spousal support should be awarded to #{ alimony_who } in the amount of $ #{ alimony_how_much } per month for #{ alimony_how_long } #{ alimony_year_month }.", text_indent
      else
        push_text 'That neither party should be awarded spousal support.', text_indent
      end

      move_down header_margin_top
      push_header '16. NAME CHANGE'
      move_down

      case wife_name_changing
      when /^Wife never/
        push_text 'That the wife never changed her name and should not have her former or maiden name restored to her.', text_indent
      when /^Wife will keep/
        push_text 'That the wife should not have her former or maiden name restored.', text_indent
      when /^Wife will return/
        push_text "That the wife should have her former or maiden name of #{ wife_name } restored to her.", text_indent
      end

      move_down header_margin_top
      push_header '17. REASON FOR DIVORCE'
      move_down

      case reason_divorce
      when /^I no longer want to be married/
        push_text 'That the husband and wife have become so incompatible in marriage that there is no possibility of reconciliation.', text_indent
      when /^I no longer want to be married and/
        push_text 'That the husband and wife have lived separated and apart for more than one year and there is no possibility of reconciliation.', text_indent
        push_text 'WHEREFORE, Plaintiff prays for a Judgment as follows:', text_indent
        push_text '1. That the bond of matrimony heretofore and now existing between Plaintiff and Defendant be dissolved and that Plaintiff be granted an absolute Decree of Divorce and that each of the parties be restored to the status of a single, unmarried person; ', text_indent
        push_text '2. That the Court grant the relief requested in this Complaint; and', text_indent
        push_text '3. For such other relief as the Court finds to be just and proper.', text_indent
      end

      move_down 30
      push_text 'DATED THIS _______day of  ___________, text_indent___'
      move_down
      push_text 'Submitted by: __________________'
      move_down
      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name }"

      move_down header_margin_top
      push_header 'VERIFICATION'
      move_down

      push_text 'Under penalties of perjury, I declare that I am the Plaintiff in the above-entitled action; that I have read the foregoing Complaint and know the contents thereof, that the pleading is true of my own knowledge, except for those matters therein contained stated upon information and belief, and that as to those matters, I believe them to be true.', text_indent

      move_down
      push_text 'I declare under penalty of perjury under the law of the State of Nevada that the foregoing is true and correct.', text_indent

      move_down 30
      push_text 'DATED THIS _______day of  ___________, text_indent___'
      move_down
      push_text 'Submitted by: __________________'
      move_down
      push_text "#{ plaintiff_first_name } #{ plaintiff_middle_name } #{ plaintiff_last_name }"

      @data_array_enum = @data_array.to_enum
    end
  end
end













