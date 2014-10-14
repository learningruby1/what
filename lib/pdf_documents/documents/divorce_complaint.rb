module PdfDocument
  class DivorceComplaint < DivorceWrapper
    include DivorceComplaintHelper
    def generate
      _counter = 0
      default_leading 5
      push_text 'COMD', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_address.classify } #{ @plaintiff_home_address_city.classify }, #{ @plaintiff_home_address_state.classify } #{ @plaintiff_home_address_zip.classify }"

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

        if @children_nevada_residency
          tmp_text += " That the minor #{ @number_of_children > 1 ? 'children are' : 'child is' } residents of the State of Nevada and #{ @number_of_children > 1 ? 'have' : 'has' } lived in this state for at least the past six (6) months."
        else
          tmp_text += " That the minor #{ @number_of_children > 1 ? 'children are not' : 'child is not' } residents of the State of  Nevada and #{ @number_of_children > 1 ? 'have not' : 'has not' } lived in this state for at least the past six (6) months."
        end
        push_text tmp_text, @text_indent
      else
        push_text 'That the parties do not have minor children who are the issue of this marriage or were adopted.', @text_indent
      end

      tmp_text = "That the wife in this case is currently pregnant."
      tmp_text += " Husband #{ @pregnacy_unborn ? 'is' : 'is not' } the father of the he unborn child. The unborn child is due to be born on #{ @pregnacy_date }" if @pregnacy
      push_text tmp_text, @text_indent

      # move_down @header_margin_top
      # push_header '4. PREGNACY'
      # move_down

      move_to_left "#{ _counter += 1 }.  MINOR CHILDREN RESIDENCY"

      if @children_nevada_residency
        if @children_residency
          push_text "That the minor #{ @number_of_children > 1 ? 'children are' : 'child is' } residents of the State of Nevada and #{ @number_of_children > 1 ? 'have' : 'has' } lived in this state for at least the past six (6) months. Nevada is the habitual residence of the #{ @number_of_children > 1 ? 'children' : 'child' } and this Court does have the jurisdiction to enter orders regarding custody and visitation", @text_indent
        end
      else
        push_text "That the minor #{ @number_of_children > 1 ? 'children are' : 'child is' } not residents of the State of  Nevada and #{ @number_of_children > 1 ? 'have' : 'has' } not lived in this state for at least the past six (6) months. The #{ @number_of_children > 1 ? 'children are' : 'child is' } residents of the State of Nevada. This Court does not have the jurisdiction to enter orders regarding custody and visitation.", @text_indent
      end

      if @children_residency && @children_nevada_residency
        move_to_left "#{ _counter += 1 }.  LEGAL CUSTODY"

        @legal_custody_parent.each_with_index do |legal_custody, index|
          case legal_custody
          when 'BOTH Parents'
            if @same_legal_custody
              push_text "That both parties are fit and proper people to be awarded JOINT LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
            else
              push_text "That both parties are fit and proper people to be awarded JOINT LEGAL custody of the minor #{ @children_names[index] }.", @text_indent
            end
          when 'Only MOM'
            if @same_legal_custody
              push_text "The #{ @mom.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
            else
              push_text "The #{ @mom.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @children_names[index] }.", @text_indent
            end
          when 'Only DAD'
            if @same_legal_custody
              push_text "The #{ @dad.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
            else
              push_text "The #{ @dad.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @children_names[index] }.", @text_indent
            end
          end
        end

        move_to_left "#{ _counter += 1 }.  PHYSICAL CUSTODY"

        @physical_custody_parent.each_with_index do |physical_custody, index|
          case physical_custody[:custody]

          when /and visit/
            case physical_custody[:custody]

            when /^With mom/
              if @same_physical_custody
                push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' } with #{ @dad.capitalize } having visitation as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
              else
                push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ @children_names[index] } with #{ @dad.capitalize } having visitation as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
              end
            when /^With dad/
              if @same_physical_custody
                push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' } with #{ @mom.capitalize } having visitation as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
              else
                push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor #{ @children_names[index] } with #{ @mom.capitalize } having visitation as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
              end
            end

          when /^Both/
            if @same_physical_custody
              push_text "That the parties are fit and proper person to be awarded JOINT PHYSICAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' } and the parties’ timeshare should be as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
            else
              push_text "That the parties are fit and proper person to be awarded JOINT PHYSICAL custody of the minor #{ @children_names[index] } and the parties’ timeshare should be as follows: #{ physical_custody[:answers].reject(&:empty?).join('; ') }.", @text_indent
            end
          when /^Only/
            case physical_custody[:custody]
            when /mom/
              if @same_physical_custody
                push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
              else
                push_text "That #{ @mom.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor #{ @children_names[index] }.", @text_indent
              end
            when /dad/
              if @same_physical_custody
                push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
              else
                push_text "That #{ @dad.capitalize } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor #{ @children_names[index] }.", @text_indent
              end
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

        move_to_left "#{ _counter += 1 }.  MINOR CHILDREN HEALTH INSURANCE"

        case @child_insurance
        when /^Both/
          push_text "That both parties should both maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule.", @text_indent
        else
          push_text "That #{ @child_insurance == 'Dad' ? @dad.capitalize : @mom.capitalize } should maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule.", @text_indent
        end

        move_to_left "#{ _counter += 1 }.  CHILD SUPPORT"
        if @joint_children_count
          amount = (@mom_month_amount.to_f * (get_percentage_for_children(@joint_children_count).to_f / 100) - @dad_month_amount.to_f * (get_percentage_for_children(@joint_children_count).to_f / 100)).abs.round(2)
          push_text "That #{ @child_suport_who == 'Dad will pay $' ? @dad.capitalize : @mom.capitalize } should pay $ #{amount} of #{ @mom_month_amount > @dad_month_amount ? @mom.capitalize : @dad.capitalize }'s gross monthly income, whichever amount is greater.", @text_indent
          push_text "The obligation to pay child support should continue until the #{ @joint_children_count > 1 ? 'children reaches' : 'child reach' } the age of 18 and no longer in high school, or 19 years of age, whichever occurs first, or emancipates.", @text_indent
        end

        case @child_suport_who
        when /^No/
          push_text "That neither party should pay child support.", @text_indent
        when /^Dad|^Mom/
          case @how_pay
          when /following/
            push_text "That #{ @child_suport_who == 'Dad will pay $' ? @dad.capitalize : @mom.capitalize } should pay $ #{ @child_suport_amount.to_i } per month for support of the parties' minor #{ @sole_primary_children_count > 1 ? 'children' : 'child' }. This amount is in compliance with NRS 125B.070.", @text_indent
          when /statutory/
            push_text "That #{ @child_suport_who == 'Dad will pay $' ? @dad.capitalize : @mom.capitalize } should pay child support of % #{ get_percentage_for_children(@child_suport_amount.to_i) }. of #{ @child_suport_who == 'Dad will pay $' ? @dad.capitalize : @mom.capitalize } gross monthly income.", @text_indent
          end
          push_text "The obligation to pay child support should continue until the #{ @sole_primary_children_count > 1 ? 'children reaches' : 'child reach' } the age of 18 and no longer in high school, or 19 years of age, whichever occurs first, or emancipates.", @text_indent
        end

        move_to_left "#{ _counter += 1 }. WAGE WITHHOLDING"

        case @request_withhold
        when 'Yes'
          push_text 'That a wage withholding order be issued against the obligor parent to secure payment of child support and spousal support, if any.', @text_indent
        when 'No'
          push_text 'That Plaintiff is not asking for wage withholding.', @text_indent
        else
          push_text 'The child support is already being collected by the DA.', @text_indent
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
          when /^Should be/
            push_text "The tax deduction for #{ @children_names[tax.second] } should be allocated per federal law.", @text_indent
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
            mom_array.push pet.join(', ') if pet != '' || pet != ','
            dad_array.push pet.join(', ') if pet != '' || pet != ','
          end

        end

        if @property_presence != 'Yes'
          mom_array.each do |p|
            push_text p, @text_indent
          end
          dad_array.each do |p|
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
            mom_array.push property.join(', ') if property != '' || property != ','
            dad_array.push property.join(', ') if property != '' || property != ','
          end
        end

        @debts_accounts.each do |property|
          case property.last
          when /^Wife will keep it/
            property.pop
            mom_array.push property.join(', ') if property != '' || property != ','
          when /^Husband will keep it/
            property.pop
            dad_array.push property.join(', ') if property != '' || property != ','
          else
            property[2] = 'Divide'
            mom_array.push property.join(', ') if property != '' || property != ','
            dad_array.push property.join(', ') if property != '' || property != ','
          end
        end

        @bank_account.each do |property|
          case property.last
          when /^Wife will keep it/
            property.pop
            mom_array.push property.join(', ') if property != '' || property != ','
          when /^Husband will keep it/
            property.pop
            dad_array.push property.join(', ') if property != '' || property != ','
          else
            property[4] = 'Divide'
            mom_array.push property.join(', ') if property != '' || property != ','
            dad_array.push property.join(', ') if property != '' || property != ','
          end
        end

        @other_properties.each do |property|
          case property.last
          when /^Wife will keep/
            property.pop
            mom_array.push property.join(', ') if property != '' || property != ','
          when /^Husband will keep/
            property.pop
            dad_array.push property.join(', ') if property != '' || property != ','
          else
            property[2] = 'Divide'
            mom_array.push property.join(', ') if property != '' || property != ','
            dad_array.push property.join(', ') if property != '' || property != ','
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
            property[property.count - 1] = 'Divide' if property.last == 'Pay with sell of home' || 'Pay with sell of land'
            mom_array.push property.join(', ') if property != '' || property != ','
            dad_array.push property.join(', ') if property != '' || property != ','
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
        push_text 'That the Plaintiff and Defendant have lived separated and apart for more than one year and there is no possibility of reconciliation.', @text_indent
        push_text 'WHEREFORE, Plaintiff prays for a Judgment as follows:', @text_indent
        push_text '1. That the bond of matrimony heretofore and now existing between Plaintiff and Defendant be dissolved and that Plaintiff be granted an absolute Decree of Divorce and that each of the parties be restored to the status of a single, unmarried person; ', @text_indent
        push_text '2. That the Court grant the relief requested in this Complaint; and', @text_indent
        push_text '3. For such other relief as the Court finds to be just and proper.', @text_indent
      when /^I no longer want to be married/
        push_text 'That the Plaintiff and Defendant have become so incompatible in marriage that there is no possibility of reconciliation.', @text_indent
      end

      move_down 30
      push_text 'DATED THIS _______day of  ___________, 20___'
      default_leading 0
      push_text 'Submitted by: __________________', 130
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }   Signature", 200

      # move_down @header_margin_top
      # default_leading 8
      start_new_page
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













