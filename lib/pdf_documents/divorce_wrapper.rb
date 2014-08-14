module PdfDocument
  class DivorceWrapper < Wrapper
    def initialize(document)

      @header_margin_top = 40
      @text_indent = 20

      @document_id = document.id
      @data_array = Array.new

      #Step zero
      steps = document.template.steps.to_enum
      answers = step_answers_enum steps.next
      @clark_nye = answers.next.answer.strip

      #First step   Your information
      answers = step_answers_enum steps.next

      @plaintiff_first_name = answers.next.answer
      @plaintiff_middle_name = answers.next.answer
      @plaintiff_last_name = answers.next.answer

      @plaintiff_date_of_birth = answers.next.answer
      @plaintiff_social_security = answers.next.answer
      @plaintiff_mailing_addres = answers.next.answer
      if answers.next.answer == "Outside the United States"
        2.times do answers.next end
        @plaintiff_city = answers.next.answer
        @plaintiff_country = answers.next.answer
      else
        @plaintiff_city = answers.next.answer
        @plaintiff_state = answers.next.answer
        2.times do answers.next end
      end
      @plaintiff_zip = answers.next.answer
      @plaintiff_phone = answers.next.answer
      @plaintiff_email = answers.next.answer
      answers.next
      @plaintiff_wife_husband = answers.next.answer

      @mom = @plaintiff_wife_husband == 'Wife' ? 'plaintiff' : 'defendant'
      @dad = @plaintiff_wife_husband == 'Wife' ? 'defendant' : 'plaintiff'

      #Second step   Your Spouse\'s Information
      answers = step_answers_enum steps.next

      @defendant_first_name = answers.next.answer
      @defendant_middle_name = answers.next.answer
      @defendant_last_name = answers.next.answer
      @defendant_date_of_birth = answers.next.answer
      @defendant_social_security = answers.next.answer
      @defendant_mailing_address = answers.next.answer
      if answers.next.answer == "Outside the United States"
        2.times do answers.next end
        @defendant_city = answers.next.answer
        @defendant_country = answers.next.answer
      else
        @defendant_city = answers.next.answer
        @defendant_state = answers.next.answer
        2.times do answers.next end
      end
      @defendant_zip = answers.next.answer

      @defendant_email = answers.next.answer
      @defendant_phone = answers.next.answer

      #Step 3   Marriage Information
      answers = step_answers_enum steps.next

      @in_the_us = answers.next.answer == 'In the United States'
      @marriage_city = answers.next.answer
      @marriage_state = answers.next.answer

      @marriage_city_town_province = answers.next.answer
      @marriage_country = answers.next.answer
      @marriage_date = answers.next.answer

      @marriage_country_string = "in the city of #{ @in_the_us ? @marriage_city : @marriage_city_town_province }"
      @marriage_country_string += @in_the_us ? " State of #{ @marriage_state }" : " Country of #{ @marriage_country }"
      @marriage_country_string += ' and have since remained husband and wife.'


      @marriage_country_string_short = "#{ @in_the_us ? @marriage_city : @marriage_city_town_province }"
      @marriage_country_string_short += @in_the_us ? " State of #{ @marriage_state }" : " Country of #{ @marriage_country }"

      #Step 4   Nevada Residency
      answers = step_answers_enum steps.next

      @lived_in_nevada_since = answers.next.answer

      #Step 5   Pregnacy
      answers = step_answers_enum steps.next
      @wife_pregnacy = answers.next.answer == 'IS currently pregnant'

      #Step 6   Children
      answers = step_answers_enum steps.next
      @children_adopted = answers.next.answer == 'Yes' rescue false
      #NOTICE: 7 merged with 6
      #Step 7   Children's Residency
      answers.next
      @children_residency = answers.next.answer == 'Yes' rescue false

      if !@children_residency

        12.times do steps.next end
      else

        #Step 8   Number of children
        answers = step_answers_enum steps.next
        answers.next.answer
        @number_of_children = answers.next.answer.to_i

        #Step 9   Child(ren)'s Information
        step = steps.next
        @children_info = Array.new
        @children_names = Array.new

        @number_of_children.times do |i|

          answers = step_answers_enum step, i
          child_info = Hash.new
          child_info[:first_name] = answers.next.answer
          child_info[:middle_name] = answers.next.answer
          child_info[:last_name] = answers.next.answer
          @children_names << "#{child_info[:first_name]} #{child_info[:middle_name]} #{child_info[:last_name]}"
          child_info[:date_of_birth] = answers.next.answer
          child_info[:social_security] = answers.next.answer
          child_info[:is_son] = answers.next.answer == 'Son'

          @children_info.push child_info
        end

        #Step 10   Legal Custody
        answers = step_answers_enum steps.next
        @legal_custody_parent = answers.next.answer

        #Step 11   Physical Custody
        step = steps.next
        @physical_custody_parent = Array.new

        @number_of_children.times do |i|
          answers = step_answers_enum step, i

          physical_custody = Hash.new

          physical_custody[:child] = get_headed_info answers.next, i
          answers.next
          physical_custody[:custody] = answers.next.answer

          @physical_custody_parent.push physical_custody
        end

        #Step 12   Holiday
        @all_holidays = Array.new

        answers = step_answers_enum steps.next

        holiday_now = answers.next.answer == 'Yes'
        answers.next
        same_schedule = answers.next.answer == 'Yes'
        holidays_amount = same_schedule ? 1 : @number_of_children

        if !holiday_now
          2.times do steps.next end
        else
          step = steps.next

          holidays_amount.times do |i|
            answers = step_answers_enum step, i

            holidays = Array.new
            child_holidays = Hash.new

            answer = answers.next
            child_holidays[:child] = get_headed_info(answer, i) if holidays_amount > 1

            7.times do
              holiday = Array.new
              holiday.push answers.next

              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end

            #Father and mother days, haven't who
            4.times do |i|
              holiday = Array.new
              holiday.push answers.next

              holiday.push answers.next.answer
              holiday.push answers.next.answer

              if i > 1
                holiday.push 'with Dad, every year'
              else
                holiday.push 'with Mom, every year'
              end

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end


            if holidays.length > 0

              child_holidays[:holidays] = holidays
              @all_holidays.push child_holidays
            end
          end

          #Step 13   More holiday
          step = steps.next

          holidays_amount.times do |i|
            answers = step_answers_enum step, i

            holidays = Array.new
            child_holidays = Hash.new

            answer = answers.next
            child_holidays[:child] = get_headed_info(answer, i) if holidays_amount > 1

            10.times do
              holiday = Array.new
              holiday.push answers.next
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end

            #Father and mother days, havent who
            2.times do |i|
              holiday = Array.new
              holiday.push answers.next
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              if i == 0
                holiday.push 'with Dad, every year'
              else
                holiday.push 'with Mom, every year'
              end

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end

            3.times do
              holiday = Array.new
              holiday.push answers.next
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end

            #Holidays have no time
            3.times do
              holiday = Array.new
              holiday.push answers.next
              holiday.push answers.next.answer
              holiday.push answers.next.answer
              holiday.push answers.next.answer

              if holiday[0].answer == '1'
                holidays.push holiday
              end
            end

            holiday = Array.new
            holiday.push answers.next
            holiday.push answers.next.answer
            holiday.push answers.next.answer
            holiday.push answers.next.answer
            holiday.push answers.next.answer
            holiday.push answers.next.answer
            holiday.push answers.next.answer

            if holiday[0].answer == '1'
              holidays.push holiday
            end

            child_holidays[:holidays] = holidays
            if @all_holidays.select{ |h| h[:child] == child_holidays[:child] }.present?
              @all_holidays.select{ |h| h[:child] == child_holidays[:child] }.first[:holidays].concat child_holidays[:holidays]
            else
              @all_holidays.push child_holidays
            end
          end
        end

        #Step 14   Children’s Health Insurance
        answers = step_answers_enum steps.next
        @child_insurance = answers.next.answer


        #Step 15   Child Support
        answers = step_answers_enum steps.next
        @child_suport_who = answers.next.answer
        @child_suport_amount = answers.next.answer

        #Step 16   Wage withholding
        answers = step_answers_enum steps.next
        answers.next.answer
        @request_withhold = answers.next.answer == 'Yes' rescue false

        #Step 17   Child  Support Arrears
        answers = step_answers_enum steps.next
        answers.next
        answers.next
        @request_arrears = answers.next.answer == 'Yes' rescue false
        @request_arrears_from = answers.next.answer
        answers.next
        @request_amount_paid = answers.next.answer

        #Step 18   Child Tax Exemption
        step = steps.next
        @child_tax_examption = Array.new

        @number_of_children.times do |i|
          answers = step_answers_enum step, i
          answers.next.answer
          @child_tax_examption.push [answers.next.answer, i, answers.next.answer]
        end
      end

      #Step 19   Pet
      answers = step_answers_enum steps.next
      @pet_presence = answers.next.answer == 'Yes' rescue false
      @pet_amount = answers.next.answer.to_i rescue 0

      if !@pet_presence
        steps.next
      else

        #Step 20   Pet custody
        step = steps.next

        @pets = Array.new
        @pet_amount.times do |i|

          answers = step_answers_enum step, i
          pet = Array.new

          pet.push 'pet'
          pet.push answers.next.answer
          pet.push answers.next.answer
          @pets.push pet
        end
      end

      #Step 21   Property
      answers = step_answers_enum steps.next
      answers.next
      @property_presence = answers.next.answer
      if @property_presence != 'Yes'
        7.times do steps.next end
      else

        #Step 22   Property Division: Marital Home
        #Deleted

        @properties_more = Array.new

        #Step 23   Property Division: Marital Home
        answers = document.step_answers steps.next

        if @property_presence

          house = answers.select{ |item| item.sort_index == 'a' }
          house.sort_by!{ |item| item.sort_number }
          if house.first.answer == '1'
            loop_answer = house.second.answer.to_i
            loop_answer.times do
              house.shift 2
              @properties_more.push ['House', house.first.answer, house.second.answer]
            end
          end

          land = answers.select{ |item| item.sort_index == 'b' }
          land.sort_by!{ |item| item.sort_number }
          if land.first.answer == '1'
            loop_answer = land.second.answer.to_i
            loop_answer.times do
              land.shift 2
              @properties_more.push ['Land', land.first.answer, land.second.answer]
            end
          end

          business = answers.select{ |item| item.sort_index == 'c' }
          business.sort_by!{ |item| item.sort_number }
          if business.first.answer == '1'
            loop_answer = business.second.answer.to_i
            business.shift 2
            loop_answer.times do
              @properties_more.push ['Business', business.first.answer, business.second.answer, business.third.answer]
              business.shift 3
            end
          end
        end

        #Step 24   Property Division: Vehicles
        answers = step_answers_enum steps.next
        @vehicles_presence = answers.next.answer == 'Yes' rescue false

        #Step 25   Property Division: Vehicles
        answers = document.step_answers steps.next
        if @vehicles_presence

          car = answers.select{ |item| item.sort_index == 'a' }
          car.sort_by!{ |item| item.sort_number }
          if car.first.answer == '1'
            loop_answer = car.second.answer.to_i
            loop_answer.times do
              car.shift 2
              @properties_more.push ['Car', car.first.answer, car.second.answer]
            end
          end

          motorcycle = answers.select{ |item| item.sort_index == 'b' }
          motorcycle.sort_by!{ |item| item.sort_number }
          if motorcycle.first.answer == '1'
            loop_answer = motorcycle.second.answer.to_i
            loop_answer.times do
              motorcycle.shift 2
              @properties_more.push ['Motorcycle', motorcycle.first.answer, motorcycle.second.answer]
            end
          end

          rv = answers.select{ |item| item.sort_index == 'c' }
          rv.sort_by!{ |item| item.sort_number }
          if rv.first.answer == '1'
            loop_answer = rv.second.answer.to_i
            loop_answer.times do
              rv.shift 2
              @properties_more.push ['RV', rv.first.answer, rv.second.answer]
            end
          end

          boat = answers.select{ |item| item.sort_index == 'd' }
          boat.sort_by!{ |item| item.sort_number }
          if boat.first.answer == '1'
            loop_answer = boat.second.answer.to_i
            loop_answer.times do
              boat.shift 2
              @properties_more.push ['Boat', boat.first.answer, boat.second.answer]
            end
          end

          trailer = answers.select{ |item| item.sort_index == 'e' }
          trailer.sort_by!{ |item| item.sort_number }
          if trailer.first.answer == '1'
            loop_answer = trailer.second.answer.to_i
            loop_answer.times do
              trailer.shift 2
              @properties_more.push ['Trailer', trailer.first.answer, trailer.second.answer]
            end
          end

          other = answers.select{ |item| item.sort_index == 'f' }
          other.sort_by!{ |item| item.sort_number }
          if other.first.answer == '1'
            loop_answer = other.second.answer.to_i
            loop_answer.times do
              other.shift 2
              @properties_more.push ['Other', other.first.answer, other.second.answer]
            end
          end

        end

        #Step 26   Property Division: Pension Benefit
        @debts_accounts = Array.new
        answers = document.step_answers steps.next

        plan = answers.select{ |item| item.sort_index == 'a' }
        plan.sort_by!{ |item| item.sort_number }
        if plan.first.answer == 'Yes'
          loop_answer = plan.second.answer.to_i
          loop_answer.times do
            plan.shift 2
            @debts_accounts.push ['Plan', plan.first.answer, plan.second.answer]
          end
        end

        #Step 27   Property Division: Bank and Investment Account
        @bank_account = Array.new
        answers = document.step_answers steps.next

        bank = answers.select{ |item| item.sort_index == 'a' }
        bank.sort_by!{ |item| item.sort_number }
        if bank.first.answer == 'Yes'
          loop_answer = bank.second.answer.to_i
          bank.shift 2
          loop_answer.times do
            @bank_account.push ['Account', bank.first.answer, bank.second.answer, bank.third.answer, bank.fourth.answer]
            bank.shift 4
          end
        end

        #Step 28   Property Division: Other
        answers = step_answers_enum steps.next
        @other_property_presence = answers.next.answer == 'Yes' rescue false

        #Step 29   Property Division: Other
        answers = step_answers_enum steps.next
        if @other_property_presence

          @other_properties = Array.new
          answers.each do |answer|
            @other_properties.push answer.template_field.to_s.split(' /<spain/>').first if answer.answer == '1'
          end
        end

      end

      #Step 30   Debts
      answers = document.step_answers steps.next
      @community_debts = answers.last.answer
      @debt_devision = Array.new

      if @community_debts == 'Yes'
        #Step 31 Debts Division
        answers = document.step_answers steps.next

        house = answers.select{ |item| item.sort_index == 'a' }
        house.sort_by!{ |item| item.sort_number }
        if house.first.answer == '1'
          tmp_house = house.first
          loop_answer = house.second.answer.to_i
          house.shift 2
          loop_answer.times do
            @debt_devision.push ['House', house.first.answer, house.second.answer, house.third.answer]
            house.shift 3
          end
        end

        land = answers.select{ |item| item.sort_index == 'b' }
        land.sort_by!{ |item| item.sort_number }
        if land.first.answer == '1'
          tmp_land = land.first
          loop_answer = land.second.answer.to_i
          land.shift 2
          loop_answer.times do
            @debt_devision.push ['Land', land.first.answer, land.second.answer, land.third.answer]
            land.shift 3
          end
        end

        #Step 32
        answers = document.step_answers steps.next

        card = answers.select{ |item| item.sort_index == 'a' }
        card.sort_by!{ |item| item.sort_number }
        if card.first.answer == '1'
          loop_answer = card.second.answer.to_i
          loop_answer.times do
            card.shift 2
            @debt_devision.push ['Credit Cards', card.first.answer, card.second.answer]
          end
        end

        hospital = answers.select{ |item| item.sort_index == 'b' }
        hospital.sort_by!{ |item| item.sort_number }
        if hospital.first.answer == '1'
          loop_answer = hospital.second.answer.to_i
          loop_answer.times do
            hospital.shift 2
            @debt_devision.push ['Hospital bills', hospital.first.answer, hospital.second.answer]
          end
        end

        doctor = answers.select{ |item| item.sort_index == 'c' }
        doctor.sort_by!{ |item| item.sort_number }
        if doctor.first.answer == '1'
          loop_answer = doctor.second.answer.to_i
          loop_answer.times do
            doctor.shift 2
            @debt_devision.push ['Doctor bills', doctor.first.answer, doctor.second.answer]
          end
        end

        #Step 33
        answers = document.step_answers steps.next

        car = answers.select{ |item| item.sort_index == 'a' }
        car.sort_by!{ |item| item.sort_number }
        if car.first.answer == '1'
          loop_answer = car.second.answer.to_i
          loop_answer.times do
            car.shift 2
            @debt_devision.push ['Car', car.first.answer, car.second.answer]
          end
        end

        rv = answers.select{ |item| item.sort_index == 'b' }
        rv.sort_by!{ |item| item.sort_number }
        if rv.first.answer == '1'
          loop_answer = rv.second.answer.to_i
          loop_answer.times do
            rv.shift 2
            @debt_devision.push ['RV', rv.first.answer, rv.second.answer]
          end
        end

        boat = answers.select{ |item| item.sort_index == 'c' }
        boat.sort_by!{ |item| item.sort_number }
        if boat.first.answer == '1'
          loop_answer = boat.second.answer.to_i
          loop_answer.times do
            boat.shift 2
            @debt_devision.push ['Boat', boat.first.answer, boat.second.answer]
          end
        end

        motorcycle = answers.select{ |item| item.sort_index == 'd' }
        motorcycle.sort_by!{ |item| item.sort_number }
        if motorcycle.first.answer == '1'
          loop_answer = motorcycle.second.answer.to_i
          loop_answer.times do
            motorcycle.shift 2
            @debt_devision.push ['Motorcycle', motorcycle.first.answer, motorcycle.second.answer]
          end
        end

        #Step 34
        answers = document.step_answers steps.next

        student = answers.select{ |item| item.sort_index == 'a' }
        student.sort_by!{ |item| item.sort_number }
        if student.first.answer == '1'
          loop_answer = student.second.answer.to_i
          loop_answer.times do
            student.shift 2
            @debt_devision.push ['Student loan', student.first.answer, student.second.answer]
          end
        end

        irs = answers.select{ |item| item.sort_index == 'b' }
        irs.sort_by!{ |item| item.sort_number }
        if irs.first.answer == '1'
          loop_answer = irs.second.answer.to_i
          loop_answer.times do
            irs.shift 2
            @debt_devision.push ['IRS', irs.first.answer, irs.second.answer]
          end
        end

        payday = answers.select{ |item| item.sort_index == 'c' }
        payday.sort_by!{ |item| item.sort_number }
        if payday.first.answer == '1'
          loop_answer = payday.second.answer.to_i
          loop_answer.times do
            payday.shift 2
            @debt_devision.push ['Payday loan', payday.first.answer, payday.second.answer]
          end
        end

        other_loan = answers.select{ |item| item.sort_index == 'd' }
        other_loan.sort_by!{ |item| item.sort_number }
        if other_loan.first.answer == '1'
          loop_answer = other_loan.second.answer.to_i
          loop_answer.times do
            other_loan.shift 2
            @debt_devision.push ['Other loan', other_loan.first.answer, other_loan.second.answer]
          end
        end

        #Step 35
        answers = document.step_answers steps.next

        other_debt = answers.select{ |item| item.sort_index == 'a' }
        other_debt.sort_by!{ |item| item.sort_number }
        if other_debt.first.answer == '1'
          loop_answer = other_debt.second.answer.to_i
          other_debt.shift 2
          loop_answer.times do
            @debt_devision.push ['Other debt', other_debt.first.answer]
            other_debt.shift
          end
        end
      else
        5.times do steps.next end
      end

      #Step 36   Spousal support or Alimony
      answers = step_answers_enum steps.next
      @alimony_presence = answers.next.answer == 'Yes' rescue false
      if @alimony_presence

        @alimony_who = answers.next.answer
        @alimony_how_much = answers.next.answer
        @alimony_year_month = answers.next.answer
        @alimony_how_long = answers.next.answer

        if @alimony_year_month == 'Year(s) (example 1 year)'
          if @alimony_how_long == '1'
            @alimony_year_month = 'year'
          else
            @alimony_year_month = 'years'
          end
        else
          if @alimony_how_long == '1'
            @alimony_year_month = 'month'
          else
            @alimony_year_month = 'months'
          end

        end
      end

      #Step 37   Wife’s Name
      answers = step_answers_enum steps.next

      @wife_name_changing = answers.next.answer
      @wife_name = answers.next.answer

      #Step 38   Reason divorce
      answers = step_answers_enum steps.next
      @reason_divorce = answers.next.answer
    end
  end
end