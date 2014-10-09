module PdfDocument
  class DivorceCoversheet < DivorceWrapper
    def generate
      push_header "CIVIL (FAMILY - RELATED) COVER SHEET"
      push_header "#{ @clark_nye } COUNTY, NEVADA"
      move_down 20

      push_header "Case No. #{ '_'*30 }  (Assigned by Clerk’s Office)", 12
      move_down 10
      push_header "#{ '_'*25 }", 10
      move_down 10

      push_text '<b>I. PARTY INFORMATION</b>'
      table_row [ { :content => 'Plaintiff/Petitioner', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 }, { :content => 'Defendant/Respondent/Co-Petitioner', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 } ]
      default_leading 4
      table_row [ { :content => "Name: #{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }
                                Address: #{ @plaintiff_mailing_address }, #{ @plaintiff_mailing_address_city }, #{ @plaintiff_mailing_address_state }, #{ @plaintiff_mailing_address_zip }
                                City, State, Zip: #{ @plaintiff_home_address }, #{ @plaintiff_home_address_city }, #{ @plaintiff_home_address_state }, #{ @plaintiff_home_address_zip }
                                Phone #: #{ @plaintiff_phone }
                                Date of Birth: #{ @plaintiff_date_of_birth }
                                <b>Attorney Information (Name/Address/Phone)</b>\n\n\n\n", :colspan => 2 },
                  { :content => "Name: #{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name }
                                Address: #{ @defendant_city }, #{ @defendant_country.present? ? @defendant_country : @defendant_state }, #{ @defendant_zip }
                                City, #{ @defendant_country.present? ? 'Country' : 'State' }, Zip: #{ @defendant_city }, #{ @defendant_country.present? ? @defendant_country : @defendant_state }, #{ @defendant_zip }
                                Phone #: #{ @defendant_phone }
                                Date of Birth: #{ @defendant_date_of_birth }
                                <b>Attorney Information (Name/Address/Phone)</b>", :colspan => 2 } ]

      push_table
      default_leading 0
      move_down 20

      push_text '<b>II. NATURE OF CONTROVERSY</b>'
      push_header "<b>Family-Related Cases</b>", 12
      table_row [ { :content => 'Domestic Relations', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 }, { :content => 'Guardianship', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 } ]
      default_leading 4
      table_row [ { :content => "<b>Marriage Dissolution Case</b>\n\b\b\b\b\b\b\b\b\b\bAnnulment\n\b\b\b\b\b\b\b\b\b\bDivorce –With children\n\b\b\b\b\b\b\b\b\b\bDivorce –Without children\n\b\b\b\b\b\b\b\b\b\bForeign Decree\n\b\b\b\b\b\b\b\b\b\bJoint Petition – With children\n\b\b\b\b\b\b\b\b\b\bJoint Petition – Without children\n\b\b\b\b\b\b\b\b\b\bSeparate Maintenance\n\n<b>\b\b\b\b\bSupport/Custody</b>\n<b>\b\b\b\b\bUIFSA Case (formerly URESA)</b>\n<b>\b\b\b\b\bAdoption</b>\n\b\b\b\b\b\b\b\b\b\bAdult\n\b\b\b\b\b\b\b\b\b\bMinor\n<b>\b\b\b\b\bPaternity</b>\n<b>\b\b\b\b\bTermination of Parental Rights</b>\n<b>\b\b\b\b\bMiscellaneous Domestic Relations</b>\n\b\b\b\b\b\b\b\b\b\bName Change\n\b\b\b\b\b\b\b\b\b\bPermission to Marry\n\b\b\b\b\b\b\b\b\b\bOther Family", :colspan => 2 },
                  { :content => "<b>\b\b\b\b\bGuardianship of an Adult</b>\n<b>\b\b\b\b\bGuardianship of a Minor</b>\n<b>\b\b\b\b\bGuardianship Trust</b>\n<b>Estimated Estate Value: $</b>\n\n<b>Other Family-Related Case Filing Type</b>\n<b>\b\b\b\b\bMental Health</b>\n<b>\b\b\b\b\bRequest for Temporary Protective Order</b>\n<b>\b\b\b\b\bMiscellaneous Juvenile</b>\n\b\b\b\b\b\b\b\b\b\bEmancipation", :colspan => 2 } ]
      small_rectangle 12, 416
      small_rectangle 12, 403
      small_rectangle 12, 390
      small_rectangle 12, 377
      small_rectangle 12, 364
      small_rectangle 12, 351
      small_rectangle 12, 338
      small_rectangle 2, 312
      small_rectangle 2, 299
      small_rectangle 2, 286
      small_rectangle 12, 273
      small_rectangle 12, 260
      small_rectangle 2, 248
      small_rectangle 2, 234
      small_rectangle 2, 221
      small_rectangle 12, 208
      small_rectangle 12, 195
      small_rectangle 12, 182

      small_rectangle 273, 429
      small_rectangle 273, 416
      small_rectangle 273, 403
      small_rectangle 273, 350
      small_rectangle 273, 337
      small_rectangle 273, 324
      small_rectangle 281, 311

      create_line 270, 540, 364
      create_line 270, 540, 353

      push_table -1
      move_down 20
      default_leading 0

      push_text '<b>Children involved in this case:</b>'
      move_down 20

      if @children_residency
        @children_info.each do |child|
          push_text "Name: #{ child[:first_name] } #{ child[:last_name] } #{ child[:middle_name] } #{ ' '*(80 - child[:first_name].length + child[:last_name].length + child[:middle_name].length) } DOB: #{ child[:date_of_birth] }"
        end
        move_down 20
      end


      push_text "<u>#{ ' '*10 } #{ Time.now.strftime("%Y-%d-%m") } #{ ' '*60}</u> #{ ' '*15} #{ '_'*30 }"
      push_text "#{ ' '*10 } Date #{ ' '*85 } Signature of Preparer #{ @plaintiff_first_name } #{ @plaintiff_last_name } #{ @plaintiff_middle_name }"

      finishing
    end
  end
end