module PdfDocument
  class DivorceCover < DivorceWrapper

    def generate
      push_header "#{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT", 12
      push_header "#{ @clark_nye.upcase } COUNTY, NEVADA", 12
      move_down
      push_header 'FAMILY COURT COVER SHEET', 12
      move_down 10
      push_header 'CASE NO.____________________________  (To be assigned by the Clerk’s Office)', 10
      move_down

      table_row [ { :content => "<font size='10'>Do you or any other party in this case (including any minor child) have any other current case(s) or past case(s) in the Family Court or Juvenile Court in Clark County?\nYES            NO\nIf yes, complete the other side of this form</font>", :align => :center, :font_style => :bold, :border_width => 3 } ]
      if @family_court
        rectangle_checked 225, 610
        rectangle 275, 610
      else
        rectangle 225, 610
        rectangle_checked 275, 610
      end
      push_table -1, 0
      move_down 20

      push_header 'PARTY INFORMATION', 10

      table_row [ { :content => 'Plaintiff/Petitioner', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 }, { :content => 'Defendant/Respondent/Co-Petitioner/Ward/Decedent', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 } ]
      table_row [ { :content => "Last Name: #{ @plaintiff_last_name }", :colspan => 2 }, { :content => "Last Name: #{ @defendant_last_name }", :colspan => 2 } ]
      table_row [ "First Name: #{ @plaintiff_first_name }", "Middle name: #{ @plaintiff_middle_name }", "First Name: #{ @defendant_first_name }", "Middle name: #{ @defendant_middle_name }" ]
      table_row [ { :content => "Home Address: #{ @plaintiff_mailing_addres }", :colspan => 2 }, { :content => "Home Address: #{ @defendant_mailing_address }", :colspan => 2 } ]

      if @defendant_country.present? && @plaintiff_country.present?
        table_row [ { :content => "Country, City, Zip: #{ @plaintiff_country }, #{ @plaintiff_city }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "Country, City, Zip: #{ @defendant_country }, #{ @defendant_city }, #{ @defendant_zip }", :colspan => 2 } ]
      elsif @defendant_country.present? && !@plaintiff_country.present?
        table_row [ { :content => "City, State, Zip: #{ @plaintiff_city }, #{ @plaintiff_state }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "Country, City, Zip: #{ @defendant_country }, #{ @defendant_city }, #{ @defendant_zip }", :colspan => 2 } ]
      elsif !@defendant_country.present? && @plaintiff_country.present?
        table_row [ { :content => "Country, City, Zip: #{ @plaintiff_country }, #{ @plaintiff_city }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "City, State, Zip: #{ @defendant_city }, #{ @defendant_state }, #{ @defendant_zip }", :colspan => 2 } ]
      else
        table_row [ { :content => "City, State, Zip: #{ @plaintiff_city }, #{ @plaintiff_state }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "City, State, Zip: #{ @defendant_city }, #{ @defendant_state }, #{ @defendant_zip }", :colspan => 2 } ]
      end

      table_row [ { :content => "Mailing Address: #{ @plaintiff_mailing_addres }", :colspan => 2 }, { :content => "Mailing Address: #{ @defendant_mailing_address }", :colspan => 2 } ]

      if @defendant_country.present? && @plaintiff_country.present?
        table_row [ { :content => "Country, City, Zip: #{ @plaintiff_country }, #{ @plaintiff_city }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "Country, City, Zip: #{ @defendant_country }, #{ @defendant_city }, #{ @defendant_zip }", :colspan => 2 } ]
      elsif @defendant_country.present? && !@plaintiff_country.present?
        table_row [ { :content => "City, State, Zip: #{ @plaintiff_city }, #{ @plaintiff_state }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "Country, City, Zip: #{ @defendant_country }, #{ @defendant_city }, #{ @defendant_zip }", :colspan => 2 } ]
      elsif !@defendant_country.present? && @plaintiff_country.present?
        table_row [ { :content => "Country, City, Zip: #{ @plaintiff_country }, #{ @plaintiff_city }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "City, State, Zip: #{ @defendant_city }, #{ @defendant_state }, #{ @defendant_zip }", :colspan => 2 } ]
      else
        table_row [ { :content => "City, State, Zip: #{ @plaintiff_city }, #{ @plaintiff_state }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "City, State, Zip: #{ @defendant_city }, #{ @defendant_state }, #{ @defendant_zip }", :colspan => 2 } ]
      end
      table_row [ "Phone: #{ @plaintiff_phone }", "Date of birth: #{ @plaintiff_date_of_birth }", "Phone: #{ @defendant_phone }", "Date of birth: #{ @defendant_date_of_birth }" ]
      push_table

      table_row [ { :content => 'Attorney Information', :colspan => 4, :align => :center, :font_style => :bold, :width => 270 }, { :content => 'Attorney Information', :colspan => 4, :align => :center, :font_style => :bold, :width => 270 } ]
      table_row [ { :content => 'Name:', :colspan => 3 }, 'Bar No.:', { :content => 'Name:', :colspan => 3 }, 'Bar No.']
      table_row [ { :content => 'Address:', :colspan => 4 }, { :content => 'Address:', :colspan => 4 } ]
      table_row [ { :content => 'City, State, Zip:', :colspan => 4 }, { :content => 'City, State, Zip:', :colspan => 4 } ]
      table_row [ { :content => 'Phone #:   Direct/Fax', :colspan => 4 }, { :content => 'Phone #:', :colspan => 4 } ]
      push_table

      move_down 20
      table_row [ { :content => 'DOMESTIC', :align => :center, :font_style => :bold, :width => 135 }, { :content => 'OTHER DOMESTIC RELATIONS<br/>PETITIONS', :align => :center, :font_style => :bold, :width => 135 }, { :content => 'GUARDIANSHIP', :align => :center, :font_style => :bold, :width => 135 }, { :content => 'PROBATE', :align => :center, :font_style => :bold, :width => 135 } ]
      default_leading 3
      table_row [ { :content => "\b\b\b\b\bAnnulment\n\b\b\b\b\bDivorce –No minor child(ren)\n\b\b\b\b\bDivorce –With minor child(ren)\n\b\b\b\b\bForeign Decree\n\b\b\b\b\bJoint Petition –No minor child(ren)\n\b\b\b\b\bJoint Petition –With minor child(ren)\n\b\b\b\b\bSeparate Maintenance" }, { :content => "\b\b\b\b\bAdoption –Minor\n\b\b\b\b\bAdoption –Adult\n\b\b\b\b\bChild Custody (Non-Divorce)\n\b\b\b\b\bMental Health\n\b\b\b\b\bName Change\n\b\b\b\b\bPaternity\n\b\b\b\b\bPermission to Marry\n\b\b\b\b\bSupport - Other\n\b\b\b\b\bTemporary Protective Order (TPO)\n\b\b\b\b\bTermination of Parental Rights\n\b\b\b\b\bVisitation (Non-Divorce)\n\b\b\b\b\bOther (identify)__________" }, { :content => "<b>\b\b\b\bGuardianship of an Adult</b>\n\b\b\b\b\bPerson\n\b\b\b\b\bEstate\n\b\b\b\b\bPerson and Estate\n\n<b>\b\b\b\bGuardianship of a Minor</b>\n\b\b\b\b\bPerson\n\b\b\b\b\bEstate\n\b\b\b\b\bPerson and Estate\n\n\b\b\b\b\b<b>\b\b\b\b\bGuardianship Trust</b>" }, { :content => "\b\b\b\b\bSummary Administration\n\b\b\b\b\bGeneral Administration\n\b\b\b\b\bSpecial Administration\n\b\b\b\b\bSet Aside Estates\n\b\b\b\b\bTrust/Conservatorships\n\b\b\b\b\b\b\b\b\bIndividual Trustee\n\b\b\b\b\b\b\b\b\bCorporate Trustee\n\b\b\b\b\bOther Probate" }]
      #first column
      rectangle 3, 218
      if @children_residency
        rectangle 3, 205
        rectangle_checked 3, 192
      else
        rectangle_checked 3, 205
        rectangle 3, 192
      end

      rectangle 3, 179
      rectangle 3, 166
      rectangle 3, 140
      rectangle 3, 113

      #second column
      rectangle 138, 218
      rectangle 138, 205
      rectangle 138, 192
      rectangle 138, 179
      rectangle 138, 166
      rectangle 138, 153
      rectangle 138, 140
      rectangle 138, 127
      rectangle 138, 114
      rectangle 138, 88
      rectangle 138, 75
      rectangle 138, 62

      #third column
      rectangle 273, 205
      rectangle 273, 192
      rectangle 273, 179
      rectangle 273, 140
      rectangle 273, 127
      rectangle 273, 114
      rectangle 273, 88

      #fouth column
      rectangle 408, 218
      rectangle 408, 205
      rectangle 408, 192
      rectangle 408, 179
      rectangle 408, 166
      rectangle 418, 153
      rectangle 418, 140
      rectangle 408, 127
      push_table

      default_leading 0
      table_row [ { :content => 'MISC. JUVENILE PETITIONS', :align => :center, :font_style => :bold, :width => 135 }, { :content => 'IV-D CHILD SUPPORT PETITIONS', :align => :center, :font_style => :bold, :colspan => 3, :width => 405 } ]
      table_row [ { :content => "\b\b\b\b\bWork Permit   \b\b\b\b\bEmancipation" }, { :content => "DA – UIFSA    \b\b\b\b\bChild Support In State IV-D", :align => :center, :colspan => 3 }]
      rectangle 3, 20
      rectangle 68, 20
      rectangle 246, 20
      rectangle 313, 20
      push_table

      if @children_residency
        move_down
        push_header 'List children involved in this case', 10
        if @children_info.count == 1
          y_position = 577
        else
          y_position = 577 - 20 * (@children_info.count - 1)
        end

        table_row [ { :content => 'First name', :align => :center, :font_style => :bold }, { :content => 'Last name', :align => :center, :font_style => :bold }, { :content => 'Middle name', :align => :center, :font_style => :bold }, { :content => 'Date of birth', :align => :center, :font_style => :bold }, { :content => 'Relationship', :align => :center, :font_style => :bold } ]
        @children_info.each_with_index do |child, i|

          table_row [ "#{ i+1 }. #{ child[:first_name] }", child[:last_name], child[:middle_name], child[:date_of_birth], "#{ child[:is_son] ? 'SON' : 'DAUGHTER' }" ]
        end
        if @children_info.count < 3
          print_index = @children_info.count
          (3 - @children_info.count).times do
            table_row [ "#{ print_index += 1 }.", "", "", "", "" ]
            y_position -= 20
          end
        end
        push_table
      else
        y_position = 537
        push_header 'List children involved in this case', 10
        table_row [ { :content => 'First name', :align => :center, :font_style => :bold }, { :content => 'Last name', :align => :center, :font_style => :bold }, { :content => 'Middle name', :align => :center, :font_style => :bold }, { :content => 'Date of birth', :align => :center, :font_style => :bold }, { :content => 'Relationship', :align => :center, :font_style => :bold } ]
        table_row [ "1.", "", "", "", "" ]
        table_row [ "2.", "", "", "", "" ]
        table_row [ "3.", "", "", "", "" ]
        push_table
      end

      move_down 20
      push_text "<u>#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }    </u>                _________________________                        ____________________"
      push_text 'Printed Name of Preparer                   Signature of Preparer                                        Date'

      #start_new_page
      move_down 20
      push_header 'Supply the following information about any other proceeding:'
      move_down
      push_header "Divorce      Temporary Protective Orders (TPO)      Custody/Child Support\nGuardianship      Paternity      Juvenile Court      Termination of Parental Rights"
      move_down 20
      if @family_court
        if @divorce
          rectangle_checked 64, y_position
        else
          rectangle 64, y_position
        end

        if @tpo
          rectangle_checked 124, y_position
        else
          rectangle 124, y_position
        end

        if @custody_support
          rectangle_checked 331, y_position
        else
          rectangle 331, y_position
        end

        if @guardianship
          rectangle_checked 52, y_position - 14
        else
          rectangle 52, y_position - 14
        end

        if @paternity
          rectangle_checked 142, y_position - 14
        else
          rectangle 142, y_position - 14
        end

        if @juvenile_court
          rectangle_checked 207, y_position - 14
        else
          rectangle 207, y_position - 14
        end

        if @termination_parental_right
          rectangle_checked 303, y_position - 14
        else
          rectangle 303, y_position - 14
        end
      else
        rectangle 64, y_position
        rectangle 124, y_position
        rectangle 331, y_position
        rectangle 52, y_position - 14
        rectangle 142, y_position - 14
        rectangle 207, y_position - 14
        rectangle 303, y_position - 14
      end

      push_header 'Please Print', 10
      if @divorce || @tpo || @custody_support || @paternity || @juvenile_court || @guardianship || @termination_parental_right
        table_row [ { :content => 'List full name of all adult parties involved', :align => :center, :font_style => :bold, :colspan => 3 }, { :content => 'Case number<br/>of other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 }, { :content => 'Approximate date<br/>of last order in other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 } ]
        table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 } ]
        print_index = 0
        if @divorce
          table_row [ "#{ print_index += 1 }. #{ @divorce_array[1] }", "#{ @divorce_array[0] }", "#{ @divorce_array[2] }", "#{ @divorce_array[6] }", "#{ @divorce_array[7] }" ]
          if @divorce_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @divorce_array[4] }", "#{ @divorce_array[3] }", "#{ @divorce_array[5] }", "#{ @divorce_array[6] }", "#{ @divorce_array[7] }" ]
          end
        end

        if @tpo
          table_row [ "#{ print_index += 1 }. #{ @tpo_array[1] }", "#{ @tpo_array[0] }", "#{ @tpo_array[2] }", "#{ @tpo_array[6] }", "#{ @tpo_array[7] }" ]
          if @tpo_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @tpo_array[4] }", "#{ @tpo_array[3] }", "#{ @tpo_array[5] }", "#{ @tpo_array[6] }", "#{ @tpo_array[7] }" ]
          end
        end

        if @custody_support
          table_row [ "#{ print_index += 1 }. #{ @custody_support_array[1] }", "#{ @custody_support_array[0] }", "#{ @custody_support_array[2] }", "#{ @custody_support_array[6] }", "#{ @custody_support_array[7] }" ]
          if @custody_support_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @custody_support_array[4] }", "#{ @custody_support_array[3] }", "#{ @custody_support_array[5] }", "#{ @custody_support_array[6] }", "#{ @custody_support_array[7] }" ]
          end
        end

        if @paternity
          table_row [ "#{ print_index += 1 }. #{ @paternity_array[1] }", "#{ @paternity_array[0] }", "#{ @paternity_array[2] }", "#{ @paternity_array[6] }", "#{ @paternity_array[7] }" ]
          if @paternity_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @paternity_array[4] }", "#{ @paternity_array[3] }", "#{ @paternity_array[5] }", "#{ @paternity_array[6] }", "#{ @paternity_array[7] }" ]
          end
        end

        if @juvenile_court
          table_row [ "#{ print_index += 1 }. #{ @juvenile_court_array[1] }", "#{ @juvenile_court_array[0] }", "#{ @juvenile_court_array[2] }", "#{ @juvenile_court_array[6] }", "#{ @juvenile_court_array[7] }" ]
          if @juvenile_court_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @juvenile_court_array[4] }", "#{ @juvenile_court_array[3] }", "#{ @juvenile_court_array[5] }", "#{ @juvenile_court_array[6] }", "#{ @juvenile_court_array[7] }" ]
          end
        end

        if @guardianship
          table_row [ "#{ print_index += 1 }. #{ @guardianship_array[1] }", "#{ @guardianship_array[0] }", "#{ @guardianship_array[2] }", "#{ @guardianship_array[6] }", "#{ @guardianship_array[7] }" ]
          if @guardianship_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @guardianship_array[4] }", "#{ @guardianship_array[3] }", "#{ @guardianship_array[5] }", "#{ @guardianship_array[6] }", "#{ @guardianship_array[7] }" ]
          end
        end

        if @termination_parental_right
          table_row [ "#{ print_index += 1 }. #{ @termination_parental_right_array[1] }", "#{ @termination_parental_right_array[0] }", "#{ @termination_parental_right_array[2] }", "#{ @termination_parental_right_array[6] }", "#{ @termination_parental_right_array[7] }" ]
          if @termination_parental_right_array[3].present?
            table_row [ "#{ print_index += 1 }. #{ @termination_parental_right_array[4] }", "#{ @termination_parental_right_array[3] }", "#{ @termination_parental_right_array[5] }", "#{ @termination_parental_right_array[6] }", "#{ @termination_parental_right_array[7] }" ]
          end
        end
        if print_index < 4
          (4 - print_index).times do
            table_row [ "#{ print_index += 1 }.", "", "", "", "" ]
          end
        end
        push_table 1
      else
        table_row [ { :content => 'List full name of all adult parties involved', :align => :center, :font_style => :bold, :colspan => 3 }, { :content => 'Case number<br/>of other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 }, { :content => 'Approximate date<br/>of last order in other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 } ]
        table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 } ]
        table_row [ "1.", "", "", "", "" ]
        table_row [ "2.", "", "", "", "" ]
        table_row [ "3.", "", "", "", "" ]
        table_row [ "4.", "", "", "", "" ]

        push_table 1
      end


      move_down
      push_header 'If children were involved (other than those listed on front page), please provide:', 10
      table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Date of birth', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Relationship', :align => :center, :font_style => :bold, :width => 108 } ]
      if !@child_array.blank? && @child_array.count > 0
        print_index = 0
        array_index = 0
        (@child_array.count / 5).times do
          if @child_array[array_index].present? || @child_array[array_index+1].present? || @child_array[array_index+2].present? || @child_array[array_index+3].present? || @child_array[array_index+4].present?
            table_row [ "#{ print_index += 1 }. #{ @child_array[array_index] }", "#{ @child_array[array_index+1] }", "#{ @child_array[array_index+2] }", "#{ @child_array[array_index+3] }", "#{ @child_array[array_index+4] }" ]
          end
          array_index += 5
        end
        if print_index < 8
          (8 - print_index).times do
            table_row [ "#{ print_index += 1 }.", "", "", "", "" ]
          end
        end

        push_table
      else
        table_row [ "1.", "", "", "", "" ]
        table_row [ "2.", "", "", "", "" ]
        table_row [ "3.", "", "", "", "" ]
        table_row [ "4.", "", "", "", "" ]
        table_row [ "5.", "", "", "", "" ]
        table_row [ "6.", "", "", "", "" ]
        table_row [ "7.", "", "", "", "" ]
        table_row [ "8.", "", "", "", "" ]

        push_table
      end

      move_down
      push_header 'Children involved in this case', 10
      table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Date of birth', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Relationship', :align => :center, :font_style => :bold, :width => 108 } ]
      table_row [ "4.", "", "", "", "" ]
      table_row [ "5.", "", "", "", "" ]
      table_row [ "6.", "", "", "", "" ]
      table_row [ "7.", "", "", "", "" ]
      table_row [ "8.", "", "", "", "" ]

      push_table

      move_down 160
      push_header 'THIS INFORMATION IS REQUIRED BY', 10
      push_header 'NRS 3.025, NRS 3.223, NRS 3.227, NRS 3.275,', 10
      push_header 'NRS 125.130, NRS 125.230,', 10
      push_header 'And will be kept in a confidential manner by the Clerk’s Office.', 10

      finishing
    end
  end
end