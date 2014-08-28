module PdfDocument
  class DivorceComplaint < DivorceWrapper
    def generate
      _counter = 0
      default_leading 5
      push_text 'COMD', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_addres }"
      if @plaintiff_country.present?
        push_text "#{ @plaintiff_country }, #{ @plaintiff_city }, #{ @plaintiff_zip }"
      else
        push_text "#{ @plaintiff_city }, #{ @plaintiff_state } #{ @plaintiff_zip }"
      end
      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"
      push_text 'Plaintiff In Proper Person', :style => :bold

      move_down 20
      push_header "#{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT"
      push_header "#{ @clark_nye.upcase } COUNTY, NEVADA"
      move_down 20

      default_leading 8
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name },", :inline_format => true
      push_text "Plaintiff,                                                             Case No:", 20
      push_text "vs.                                                                             Dept. No."
      push_text "#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name },", :inline_format => true
      push_text 'Defendant.',80

      move_down 30
      push_header 'COMPLAINT FOR DIVORCE'

      push_text "COMES NOW Plaintiff, #{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }, in Proper Person, and files this Complaint for Divorce against the above Defendant, and alleges as follows:", @text_indent

      move_to_left "#{ _counter += 1 }.  RESIDENCY"
      push_text "That the Plaintiff  has been and continues to be an actual, bona fide resident of #{ @clark_nye.upcase } County,  Nevada and has been actually physically present and domiciled in the State of Nevada for more than six (6) weeks prior to the filing of this action.", @text_indent

      move_to_left "#{ _counter += 1 }.  DATE OF MARRIAGE"
      push_text "That the parties were married on #{ @marriage_date } #{ @marriage_country_string }", @text_indent

      move_to_left "#{ _counter += 1 }.  MINOR CHILDREN"
      if @children_residency
        tmp_text = "That the parties have #{ @number_of_children } minor #{ @number_of_children > 1 ? 'children' : 'child' } to wit:"

        @children_info.each do |c|
          tmp_text += " #{ c[:first_name] } #{ c[:middle_name] } #{ c[:last_name] } born #{ c[:date_of_birth] }, "
        end
        tmp_text += " who #{ @number_of_children > 1 ? 'are' : 'is' } the issue of this marriage, and here are no other minor children adopted or otherwise."

        if @children_adopted
          tmp_text += " That the minor #{ @number_of_children > 1 ? 'children are' : 'child is' } residents of the State of Nevada and #{ @number_of_children > 1 ? 'have' : 'has' } lived in this state for at least the past six (6) months."
        else
          tmp_text += " That the minor #{ @number_of_children > 1 ? 'children are not' : 'child is not' } residents of the State of  Nevada and #{ @number_of_children > 1 ? 'have not' : 'has not' } lived in this state for at least the past six (6) months."
        end
        push_text tmp_text, @text_indent
      else
        push_text 'That the parties do not have minor children who are the issue of this marriage or were adopted.', @text_indent
      end

      # move_down @header_margin_top
      # push_header '4. PREGNACY'
      # move_down

      push_text "That the wife in this case #{ @wife_pregnacy ? 'is' : 'is not' } currently pregnant.", @text_indent

      if @children_adopted && @children_residency
        move_to_left "#{ _counter += 1 }.  LEGAL CUSTODY"

        case @legal_custody_parent
        when 'BOTH Parents'
          push_text "That both parties are fit and proper people to be awarded JOINT LEGAL custody of the #{ @children_names.join(', ') }.", @text_indent
        when 'Only MOM'
          push_text "#{ @mom.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }", @text_indent
        when 'Only DAD'
          push_text "#{ @dad.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }", @text_indent
        end

        move_to_left "#{ _counter += 1 }.  PHYSICAL CUSTODY"

        @physical_custody_parent.each do |physical_custody|

          case physical_custody[:custody]

          when /and visit/
            case physical_custody[:custody]

            when /^With mom/
              push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the #{ @children_names[physical_custody[:number].to_i] } with #{ @dad.capitalize } having visitation as follows: (insert the proposed visitation schedule).", @text_indent
            when /^With dad/
              push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the #{ @children_names[physical_custody[:number].to_i] } with #{ @mom.capitalize } having visitation as follows: (insert the proposed visitation schedule).", @text_indent
            end

          when /^Both/
            push_text "That the parties are fit and proper person to be awarded JOINT PHYSICAL custody of the #{ @children_names[physical_custody[:number].to_i] } and the parties’ timeshare should be as follows: (insert the proposed timeshare)", @text_indent


          when /^Only/
            case physical_custody[:custody]
            when /mom/
              push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor.", @text_indent
            when /dad/
              push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor.", @text_indent
            end
          end
        end

        move_to_left "#{ _counter += 1 }.  HOLIDAYS VISITATION"

        if @all_holidays.length > 0

          push_text 'That the parties should follow the following Holiday schedule:', @text_indent

          @all_holidays.each do |holiday|
            push_text holiday[:child]

            holiday[:holidays].each do |holy|
              holiday_string = holy[0].template_field.name.split(' /<spain/>').first
              case holy.count
              when 3
                holiday_string += ": from #{ holy[1] } to #{ holy[2] }"
              when 4
                holiday_string += ": from #{ holy[1] } to #{ holy[2] }, #{ holy[3] }"
              when 5
                holiday_string += ": from #{ holy[1] } to #{ holy[2] } with #{ holy[3] }, #{ holy[4] }"
              when 7
                holiday_string += ": #{ holy[1] }, #{ holy[2] } from #{ holy[3] } to #{ holy[4] }, with #{ holy[5] }, #{ holy[6] }"
              end
              push_text holiday_string, @text_indent
            end
          end
        else
          push_text 'That the parties should not follow a specific Holiday schedule.', @text_indent
        end

        move_to_left "#{ _counter += 1 }.  CHILD INSURANCE"

        case @child_insurance
        when /^Both/
          push_text "That both parties should both maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule.", @text_indent
        else
          push_text "That #{ @child_insurance == 'Dad' ? @dad.capitalize : @mom.capitalize } should maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule.", @text_indent
        end

        move_to_left "#{ _counter += 1 }.  CHILD SUPPORT"

        case @child_suport_who
        when /^No/
          push_text "That neither party should pay child support.", @text_indent
        when /^Dad|^Mom/
          push_text "That #{ @child_suport_who == 'Dad will pay $' ? @dad.capitalize : @mom.capitalize } should pay $ #{ @child_suport_amount } per month for support of the parties' minor #{ @number_of_children > 1 ? 'children' : 'child' }. This amount is in compliance with NRS 125B.070. The obligation to pay child support should continue until the #{ @number_of_children > 1 ? 'children' : 'child' } #{ @number_of_children > 1 ? 'reach' : 'reaches' } the age of 18 and no longer in high school, or 19 years of age, whichever occurs first, or emancipates.", @text_indent
        end

        move_to_left "#{ _counter += 1 }. WAGE WITHHOLDING"

        if @request_withhold
          push_text 'That a wage withholding order be issued against the obligor parent to secure payment of child support and spousal support, if any.', @text_indent
        else
          push_text 'That Plaintiff is not asking for wage withholding.', @text_indent
        end

        move_to_left "#{ _counter += 1 }.  CHILD SUPPORT ARREARS"

        if @request_arrears
          push_text "That Plaintiff should be awarded back child support from #{ @request_arrears_from }, which is when the parties separated and Plaintiff become the custodial parent, Plaintiff asks that this award be reduced to judgment and collectable by any legal means.", @text_indent
        else
          push_text 'The Plaintiff is not asking for back child support and waives Plaintiff’s rights to child support arrears.', @text_indent
        end

        move_to_left "#{ _counter += 1 }.  TAX DEDUCTION / EXEMPTIONS"
        @child_tax_examption.each do |tax|

          case tax.first
          when /^Mom every|^Dad every/
            push_text "That #{ tax.first == 'Mom every year' ? @mom.capitalize : @dad.capitalize} should claim the minor child: #{ @children_names[tax.second] }, as dependent for Federal Tax purposes every year.", @text_indent
          when /^Dad and Mom/
            if @number_of_children == 1
              push_text "That the parties should alternate claiming the minor child: #{ @children_names.first }, as dependent(s) for Federal Tax purposes. Plaintiff will start claiming the child starting #{tax.last}.", @text_indent
            elsif @number_of_children > 1
              push_text "That Plaintiff should claim minor #{ @children_names[tax.second] }, as dependent(s) for Federal Tax purposes every year.  Defendant should claim minor #{ @children_names[tax.second] }, as dependent(s) for Federal Tax purposes every year.", @text_indent
            end
          end

        end

      # End of children
      end

      move_to_left "#{ _counter += 1 }.  COMMUNITY PROPERTY"
      mom_array = []
      dad_array = []
      other_chosen = []
      mom_array.push "To the #{ @mom.capitalize}, as her sole and separate property: "
      dad_array.push "To the #{ @dad.capitalize}, as his sole and separate property: "
      if @pet_presence
        push_text 'That there are community property which should be divided by the Court as follows:', @text_indent
        @pets.each do |pet|

          case pet.last
          when /^Wife will keep/
            pet.pop
            mom_array.push pet.join(', ') if pet != '' || pet != ','
          when /^Husband will keep/
            pet.pop
            dad_array.push pet.join(', ') if pet != '' || pet != ','
          else
            pet.pop
            other_chosen.push pet.join(', ') if pet != '' || pet != ','
          end

        end

        if @property_presence != 'Yes'
          mom_array.each do |p|
            push_text p, @text_indent
          end
          dad_array.each do |p|
            push_text p, @text_indent
          end
          other_chosen.each do |p|
            push_text p, @text_indent
          end
        end
      end

      case @property_presence
      when 'Yes'
        push_text 'That there are community property which should be divided by the Court as follows:', @text_indent if !@pet_presence

        @properties_more.each do |property|
          case property.last
          when /^Wife will keep/
            property.pop
            mom_array.push property.join(', ') if property != '' || property != ','
          when /^Husband will keep/
            property.pop
            dad_array.push property.join(', ') if property != '' || property != ','
          else
            property[property.count - 1] = 'Sell'
            if @mom == 'plaintiff'
              mom_array.push property.join(', ') if property != '' || property != ','
            else
              dad_array.push property.join(', ') if property != '' || property != ','
            end
          end
        end

        @debts_accounts.each do |property|
          if @mom == 'plaintiff'
            case property.last
            when /^I will keep/
              property.pop
              mom_array.push property.join(', ') if property != '' || property != ','
            when /^My spouse will keep/
              property.pop
              dad_array.push property.join(', ') if property != '' || property != ','
            else
              property[2] = 'Portion'
              mom_array.push property.join(', ') if property != '' || property != ','
            end
          else
            case property.last
            when /^I will keep/
              property.pop
              dad_array.push property.join(', ') if property != '' || property != ','
            when /^My spouse will keep/
              property.pop
              mom_array.push property.join(', ') if property != '' || property != ','
            else
              property[2] = 'Portion'
              dad_array.push property.join(', ') if property != '' || property != ','
            end
          end
        end

        @bank_account.each do |property|
          if @mom == 'plaintiff'
            case property.last
            when /^I will keep/
              property.pop
              mom_array.push property.join(', ') if property != '' || property != ','
            when /^My spouse will keep/
              property.pop
              dad_array.push property.join(', ') if property != '' || property != ','
            else
              property[4] = 'Portion'
              mom_array.push property.join(', ') if property != '' || property != ','
            end
          else
            case property.last
            when /^I will keep/
              property.pop
              dad_array.push property.join(', ') if property != '' || property != ','
            when /^My spouse will keep/
              property.pop
              mom_array.push property.join(', ') if property != '' || property != ','
            else
              property[4] = 'Portion'
              dad_array.push property.join(', ') if property != '' || property != ','
            end
          end
        end

        if @other_property_presence
          @other_properties.each do |other_property|
            if @mom.capitalize == 'Plaintiff'
              mom_array.push other_property
            else
              dad_array.push other_property
            end
          end
        end

        if @mom == 'plaintiff'
          alphabet = 96
          mom_array.each_with_index do |p, index|
            if mom_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
          alphabet = 96
          dad_array.each_with_index do |p, index|
            if dad_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
        else
          alphabet = 96
          dad_array.each_with_index do |p, index|
            if dad_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
          alphabet = 96
          mom_array.each_with_index do |p, index|
            if mom_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
        end
        alphabet = 97
        other_chosen.each_with_index do |p, index|
          push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
        end

        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent
      when 'No, we already divided them'
        push_text 'That the parties have already made an equal distribution of their community property.', @text_indent
      else # Means 'No'
        push_text ' That there is no community property which should be divided by the Court. Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent
      end

      move_to_left "#{ _counter += 1 }.  COMMUNITY DEBTS"
      case @community_debts
      when 'Yes'
        push_text 'That there are community debts which should be divided by the Court as follows:', @text_indent

        mom_array = []
        dad_array = []
        other_chosen = []
        mom_array.push "To the #{ @mom.capitalize}: "
        dad_array.push "To the #{ @dad.capitalize}: "

        @debt_devision.each do |property|
          case property.last
          when /^Wife will keep/
            property.pop
            mom_array.push property.join(', ') if property != '' || property != ','
          when /^Husband will keep/
            property.pop
            dad_array.push property.join(', ') if property != '' || property != ','
          else
            property[property.count - 1] = 'Sell' if property.last == 'Pay with sell of home'
            if @mom == 'plaintiff'
              mom_array.push property.join(', ') if property != '' || property != ','
            else
              dad_array.push property.join(', ') if property != '' || property != ','
            end
          end
        end
        if @mom == 'plaintiff'
          alphabet = 96
          mom_array.each_with_index do |p, index|
            if mom_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
          alphabet = 96
          dad_array.each_with_index do |p, index|
            if dad_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
        else
          alphabet = 96
          dad_array.each_with_index do |p, index|
            if dad_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
          alphabet = 96
          mom_array.each_with_index do |p, index|
            if mom_array.first == p
              push_text p, @text_indent
            else
              push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
            end
          end
        end
        alphabet = 97
        other_chosen.each_with_index do |p, index|
          push_text "#{ (alphabet+index).chr }. #{ p }", @text_indent
        end

        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent
      when 'No, we already divided them'
        push_text 'That the parties have already equally divided their existing community debts.', @text_indent
      when 'No'
        push_text 'There are no community debts which should be divided by the court. Plaintiff ask for leave to amend the Complaint once other debts are discovered and identified', @text_indent
      end

      move_to_left "#{ _counter += 1 }.  SPOUSAL SUPPORT"

      if @alimony_presence
        push_text "That spousal support should be awarded to #{ @alimony_who == 'Wife WILL PAY spousal support $' ? @mom.capitalize : @dad.capitalize} in the amount of $ #{ @alimony_how_much } per month for #{ @alimony_how_long } #{ @alimony_year_month.downcase }.", @text_indent
      else
        push_text 'That neither party should be awarded spousal support.', @text_indent
      end

      move_to_left "#{ _counter += 1 }.  NAME CHANGE"

      case @wife_name_changing
      when /^Wife never/
        push_text 'That the wife never changed her name and should not have her former or maiden name restored to her.', @text_indent
      when /^Wife will keep/
        push_text 'That the wife should not have her former or maiden name restored.', @text_indent
      when /^Wife will return/
        push_text "That the wife should have her former or maiden name of #{ @wife_name } restored to her.", @text_indent
      end

      move_to_left "#{ _counter += 1 }.  REASON FOR DIVORCE"

      case @reason_divorce
      when /^I no longer want to be married and/
        push_text 'That the husband and wife have lived separated and apart for more than one year and there is no possibility of reconciliation.', @text_indent
        push_text 'WHEREFORE, Plaintiff prays for a Judgment as follows:', @text_indent
        push_text '1. That the bond of matrimony heretofore and now existing between Plaintiff and Defendant be dissolved and that Plaintiff be granted an absolute Decree of Divorce and that each of the parties be restored to the status of a single, unmarried person; ', @text_indent
        push_text '2. That the Court grant the relief requested in this Complaint; and', @text_indent
        push_text '3. For such other relief as the Court finds to be just and proper.', @text_indent
      when /^I no longer want to be married/
        push_text 'That the husband and wife have become so incompatible in marriage that there is no possibility of reconciliation.', @text_indent
      end

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













