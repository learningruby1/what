module PdfDocument
  class DivorceComplaint < DivorceWrapper
    def generate
      push_text 'COMD', :style => :bold
      move_down

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      move_down
      push_text "#{ @plaintiff_city } #{ @plaintiff_state } #{ @plaintiff_zip }"
      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"

      move_down
      push_text 'Plaintiff In Proper Person', :style => :bold

      move_down 20
      push_header "#{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT"
      push_header "#{ @clark_nye } JUDICIAL DISTRICT COURT"
      move_down 20

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name } Plaintiff,", :inline_format => true
      push_text 'vs.'
      push_text "#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name } Defendant", :inline_format => true

      move_down 30
      push_header 'COMPLAINT FOR DIVORCE'
      move_down

      push_text "COMES NOW Plaintiff, #{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }, in Proper Person, and files this Complaint for Divorce against the above Defendant, and alleges as follows:", @text_indent

      move_down @header_margin_top
      push_header '1. RESIDENCY'
      move_down

      push_text "That the Plaintiff  has been and continues to be an actual, bona fide resident of the #{ @clark_nye } County,  Nevada and has been actually physically present and domiciled in the State of Nevada for more than six (6) weeks prior to the filing of this action.", @text_indent

      move_down @header_margin_top
      push_header '2. DATE OF MARRIAGE'
      move_down

      push_text "That the parties were married on the #{ @marriage_date } #{ @marriage_country_string }", @text_indent

      move_down @header_margin_top
      move_down @header_margin_top
      push_header '3. MINOR CHILDREN'
      move_down

      if @children_residency
        push_text "That the parties have #{ @number_of_children } minor #{ @number_of_children > 1 ? 'children' : 'child' } to wit:", @text_indent

        @children_info.each do |c|
          move_down
          push_text "#{ c[:first_name] } #{ c[:middle_name] } #{ c[:last_name] } born #{ c[:date_of_birth] }, security # #{ c[:social_security] }, #{ c[:is_son] ? 'son' : 'daughter' }", @text_indent
          move_down
        end

        push_text "That the minor #{ @number_of_children > 1 ? 'children are' : 'child is' } residents of the State of  Nevada and #{ @number_of_children > 1 ? 'have' : 'has' } lived in this state for at least the past six (6) months.", @text_indent
      elsif @children_adopted
        push_text "That the minor children are not residents of the State of Nevada and have not lived in this state for at least the past six (6) months.", @text_indent
      else
        push_text 'That the parties do not have minor children who are the issue of this marriage or were adopted.', @text_indent
      end

      # move_down @header_margin_top
      # push_header '4. PREGNACY'
      # move_down

      push_text "That the wife in this case #{ @wife_pregnacy ? 'is' : 'not' } currently pregnant.", @text_indent

      if @children_adopted && @children_residency

        move_down @header_margin_top
        push_header '5. LEGAL CUSTODY'
        move_down

        case @legal_custody_parent
        when 'Both Parents'
          push_text "That both parties are fit and proper people to be awarded JOINT LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }.", @text_indent
        when 'Only MOM'
          push_text "#{ @mom.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }", @text_indent
        when 'Only DAD'
          push_text "#{ @dad.capitalize } is a fit and proper person to be awarded SOLE LEGAL custody of the minor #{ @number_of_children > 1 ? 'children' : 'child' }", @text_indent
        end

        move_down @header_margin_top
        push_header '6. PHYSICAL CUSTODY'
        move_down

        @physical_custody_parent.each do |physical_custody|

          case physical_custody[:custody]

          when /and visit/
            case physical_custody[:custody]

            when /^With mom/
              push_text "#{ physical_custody[:child] }: That #{ @mom } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor child with dad having visitation as follows: (insert the proposed visitation schedule)", @text_indent
            when /^With dad/
              push_text "#{ physical_custody[:child] }: That #{ @dad } is a fit and proper person to be awarded PRIMARY PHYSICAL custody of the minor child with mom having visitation as follows: (insert the proposed visitation schedule)", @text_indent
            end

          when /^Both/
            push_text "#{ physical_custody[:child] }: That the parties are fit and proper person to be awarded JOINT PHYSICAL custody of the minor child and the parties’ timeshare should be as follows: (insert the proposed timeshare)", @text_indent


          when /^Only/
            case physical_custody[:custody]
            when /mom/
              push_text "#{ physical_custody[:child] }: That #{ @mom } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor.", @text_indent
            when /dad/
              push_text "#{ physical_custody[:child] }: That #{ @dad } is a fit and proper person to be awarded SOLE PHYSICAL custody of the minor.", @text_indent
            end
          end
        end

        move_down @header_margin_top
        push_header '7. HOLIDAYS VISITATION'
        move_down

        if @all_holidays.length > 0

          push_text 'That the parties should follow the following Holiday schedule:'
          move_down

          @all_holidays.each do |holiday|

            push_text holiday[:child]
            holiday[:holidays].each do |holy|

              holiday_string = holy[0].template_field.name.split(' /<spain/>').first
              case holy.count
              when 3
                holiday_string += ": from #{ holy[1] } to #{ holy[2] }"
              when 4
                holiday_string += ": #{ holy[1] } with #{ holy[2] }, #{ holy[3] }"
              when 5
                holiday_string += ": from #{ holy[1] } to #{ holy[2] } with #{ holy[3] }, #{ holy[4] }"
              when 7
                holiday_string += ": #{ holy[1] }, #{ holy[2] } from #{ holy[3] } to #{ holy[4] }, with #{ holy[5] }, #{ holy[6] }"
              end
              push_text holiday_string, @text_indent

            end
          end
        else
          push_text 'That the parties should not follow a specific Holiday schedule.'
        end

        move_down @header_margin_top
        push_header '8. CHILD INSURANCE'
        move_down

        case @child_insurance
        when /^Both/
          push_text "That both parties should both maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule."
        else
          push_text "That #{ @child_insurance == 'Dad' ? @dad : @mom } should maintain medical and dental insurance for the minor #{ @number_of_children > 1 ? 'children' : 'child' } if available.  Any deductibles and expenses not covered by insurance should be paid equally by both parties, pursuant to the 30/30 Rule."
        end

        move_down @header_margin_top
        push_header '9. CHILD SUPPORT'
        move_down

        case @child_suport_who
        when /^No/
          push_text @child_suport_who
        when /^Dad|^Mom/
          push_text "That #{ @child_suport_who == 'Dad will pay $' ? dad : mom } should pay $ #{ @child_suport_amount } per month for support of the parties' minor #{ @number_of_children > 1 ? 'children' : 'child' }. This amount is in compliance with NRS 125B.070. The obligation to pay child support should continue until the #{ @number_of_children > 1 ? 'children' : 'child' } #{ @number_of_children > 1 ? 'reaches' : 'reach' } the age of 18 and no longer in high school, or 19 years of age, whichever occurs first, or emancipates.", @text_indent
        end

        move_down @header_margin_top
        push_header '10. WAGE WITHHOLDING'
        move_down

        if @request_withhold
          push_text 'That a wage withholding order be issued against the obligor parent to secure payment of child support and spousal support, if any.'
        else
          push_text 'That Plaintiff is not asking for wage withholding.'
        end

        move_down @header_margin_top
        push_header '11. CHILD SUPPORT ARREARS'
        move_down

        if @request_arrears
          push_text "That Plaintiff should be awarded back child support from #{ @request_arrears_from }, which is when the parties separated and Plaintiff become the custodial parent, Plaintiff asks that this award be reduced to judgment and collectable by any legal means."
        else
          push_text 'The Plaintiff is not asking for back child support and waives Plaintiff’s rights to child support arrears.'
        end

        move_down @header_margin_top
        push_header '12. TAX DEDUCTION / EXEMPTIONS'
        move_down

        case @tax_examption_who
        when /^Mom every|^Dad every/
          push_text "That #{ @tax_examption_who } should claim the minor #{ @number_of_children > 1 ? 'children' : 'child' }. as #{ @number_of_children > 1 ? 'dependents' : 'dependent' } for Federal Tax purposes every year."
        when /^Dad and Mom/
          push_text "That the parties should alternate claiming the minor #{ @number_of_children > 1 ? 'children' : 'child' }. as dependent(s) for Federal Tax purposes."
        end

      # End of children
      end

      move_down @header_margin_top
      push_header '13. COMMUNITY PROPERTY'
      move_down

      case @property_presence
      when 'Yes'
        push_text 'That there are community debts which should be divided by the Court as follows:', @text_indent
        move_down

        if @property_marital_presence

          push_text "Marital home: #{ @property_marital_address }, #{ @property_marital_who }", @text_indent
        end

        @properties_more.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i != 1 && i % 3 == 0
              push_text property_string, @text_indent if property_string != '' || property_string != ','
              property_string = p.answer == '1' ? p.template_field.name.split(' /<spain/>').first : ''
            else
              property_string += ", #{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end

        move_down
        if @other_property_presence

          push_text 'Plaintiff wants to keep next properties:', @text_indent
          @other_properties.each do |other_property|
            push_text "#{ @other_property }", @text_indent
          end
        end

        move_down
        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent

        move_down @header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down

        push_text 'That there are community debts which should be divided by the Court as follows:', @text_indent
        #push_text 'To the Plaintiff:',
        #  20
        move_down

        @debts_accounts.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i % 2 == 0
              push_text property_string + ", #{ p.answer }", @text_indent if property_string != '' && property_string != ', Yes'
              property_string = p.answer == 'Yes' ? p.template_field.template_step.to_s.split(' /<spain/>').first.split(': ').last.strip : ''
            else
              property_string += ', ' if property_string.length > 0
              property_string += "#{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end

        @bank_account.each do |property|
          property_string = ''
          property.each_with_index do |p, i|

            if i % 4 == 0
              push_text property_string + ", #{ p.answer }", @text_indent if property_string != '' && property_string != ', Yes'
              property_string = p.answer == 'Yes' ? p.template_field.template_step.to_s.split('<br/><spain/>').first.split(': ').last.strip : ''
            else
              property_string += ', ' if property_string.length > 0
              property_string += "#{ p.answer }" if !p.answer.nil? && p.answer.length > 0
            end
          end
        end

        move_down
        push_text 'Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent

      when 'No, we already divided them'
        push_text 'That the parties have already made an equal distribution of their community property.', @text_indent

        move_down @header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down
        push_text 'That the parties have already equally divided their existing community debts.'
      else # Means 'No'
        push_text ' That there is no community property which should be divided by the Court. Plaintiff asks for leave to amend the Complaint once other assets are discovered and identified.', @text_indent

        move_down @header_margin_top
        push_header '14. COMMUNITY DEBTS'
        move_down
        push_text 'There are no community debts which should be divided by the court. Plaintiff ask for leave to amend the Complaint once other debts are discovered and identified'
      end

      move_down @header_margin_top
      push_header '15. SPOUSAL SUPPORT'
      move_down

      if @alimony_presence
        push_text "That spousal support should be awarded to #{ @alimony_who } in the amount of $ #{ @alimony_how_much } per month for #{ @alimony_how_long } #{ @alimony_year_month }.", @text_indent
      else
        push_text 'That neither party should be awarded spousal support.', @text_indent
      end

      move_down @header_margin_top
      push_header '16. NAME CHANGE'
      move_down

      case @wife_name_changing
      when /^Wife never/
        push_text 'That the wife never changed her name and should not have her former or maiden name restored to her.', @text_indent
      when /^Wife will keep/
        push_text 'That the wife should not have her former or maiden name restored.', @text_indent
      when /^Wife will return/
        push_text "That the wife should have her former or maiden name of #{ @wife_name } restored to her.", @text_indent
      end

      move_down @header_margin_top
      push_header '17. REASON FOR DIVORCE'
      move_down

      case @reason_divorce
      when /^I no longer want to be married/
        push_text 'That the husband and wife have become so incompatible in marriage that there is no possibility of reconciliation.', @text_indent
      when /^I no longer want to be married and/
        push_text 'That the husband and wife have lived separated and apart for more than one year and there is no possibility of reconciliation.', @text_indent
        push_text 'WHEREFORE, Plaintiff prays for a Judgment as follows:', @text_indent
        push_text '1. That the bond of matrimony heretofore and now existing between Plaintiff and Defendant be dissolved and that Plaintiff be granted an absolute Decree of Divorce and that each of the parties be restored to the status of a single, unmarried person; ', @text_indent
        push_text '2. That the Court grant the relief requested in this Complaint; and', @text_indent
        push_text '3. For such other relief as the Court finds to be just and proper.', @text_indent
      end

      move_down 30
      push_text 'DATED THIS _______day of  ___________, @text_indent___'
      move_down
      push_text 'Submitted by: __________________'
      move_down
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"

      move_down @header_margin_top
      push_header 'VERIFICATION'
      move_down

      push_text 'Under penalties of perjury, I declare that I am the Plaintiff in the above-entitled action; that I have read the foregoing Complaint and know the contents thereof, that the pleading is true of my own knowledge, except for those matters therein contained stated upon information and belief, and that as to those matters, I believe them to be true.', @text_indent

      move_down
      push_text 'I declare under penalty of perjury under the law of the State of Nevada that the foregoing is true and correct.', @text_indent

      move_down 30
      push_text 'DATED THIS _______day of  ___________, @text_indent___'
      move_down
      push_text 'Submitted by: __________________'
      move_down
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"

      finishing
    end
  end
end













