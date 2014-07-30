module PdfDocument
  class DivorceCover < DivorceWrapper

    def generate
      push_header "#{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT", 12
      push_header "#{ @clark_nye } JUDICIAL DISTRICT COURT", 12
      move_down
      push_header 'FAMILY COURT COVER SHEET', 12
      move_down 10
      push_header 'CASE NO.____________________________  (To be assigned by the Clerk’s Office)', 10
      move_down

      table_row [ { :content => '<font size="10">Do you or any other party in this case (including any minor child) have any other current case(s) or past case(s) in the Family Court or Juvenile Court in Clark County?<br/>0 YES            0 NO<br/>If yes, complete the other side of this form</font>', :align => :center, :font_style => :bold, :border_width => 3 } ]
      push_table -1
      move_down 20

      push_header 'PARTY INFORMATION', 10

      table_row [ { :content => 'Plaintiff', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 }, { :content => 'Defendant', :colspan => 2, :align => :center, :font_style => :bold, :width => 270 } ]
      table_row [ { :content => "Last Name: #{ @plaintiff_last_name }", :colspan => 2 }, { :content => "Last Name: #{ @defendant_last_name }", :colspan => 2 } ]
      table_row [ "First Name: #{ @plaintiff_first_name }", "Middle name: #{ @plaintiff_middle_name }", "First Name: #{ @defendant_first_name }", "Middle name: #{ @defendant_middle_name }" ]
      table_row [ { :content => "Home Address: no such field", :colspan => 2 }, { :content => "Home Address: no such field", :colspan => 2 } ]
      table_row [ { :content => "City, State, Zip: no such fields", :colspan => 2 }, { :content => "City, State, Zip: no such fields", :colspan => 2 } ]
      table_row [ { :content => "Mailing Address: #{ @plaintiff_mailing_addres }", :colspan => 2 }, { :content => "Mailing Address: #{ @defendant_mailing_address }", :colspan => 2 } ]
      table_row [ { :content => "City, State, Zip: #{ @plaintiff_city }, #{ @plaintiff_state }, #{ @plaintiff_zip }", :colspan => 2 }, { :content => "City, State, Zip: #{ @defendant_city }, #{ @defendant_state }, #{ @defendant_zip }", :colspan => 2 } ]
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
      table_row [ { :content => '' }, '', '', '']
      push_table

      table_row [ { :content => 'MISC. JUVENILE PETITIONS', :align => :center, :font_style => :bold, :width => 135 }, { :content => 'IV-D CHILD SUPPORT PETITIONS', :align => :center, :font_style => :bold, :colspan => 3, :width => 405 } ]
      table_row [ '', { :content => '', :colspan => 3 }]
      push_table

      if @children_info.length > 0
        move_down
        push_header 'List children involved in this case', 10

        table_row [ { :content => 'First name', :align => :center, :font_style => :bold }, { :content => 'Last name', :align => :center, :font_style => :bold }, { :content => 'Middle name', :align => :center, :font_style => :bold }, { :content => 'Date of birth', :align => :center, :font_style => :bold }, { :content => 'Relationship', :align => :center, :font_style => :bold } ]
        @children_info.each_with_index do |child, i|

          table_row [ "#{ i+1 }. #{ child[:first_name] }", child[:last_name], child[:middle_name], child[:birthday], 'no such fild' ]
        end
        push_table
      end

      move_down 20
      push_text '______________________                _________________________                        ____________________'
      push_text 'Printed Name of Preparer                   Signature of Preparer                                        Date'

      start_new_page

      push_header 'Supply the following information about any other proceeding:'
      move_down
      push_header '0 Divorce    0 Temporary Protective Orders (TPO)   0 Custody/Child Support<br/>0 UIFSA/URESA   0 Paternity    0 Juvenile Court    0 Other'
      move_down 20

      push_header 'Please Print', 10
      table_row [ { :content => 'List full name of all adult parties involved', :align => :center, :font_style => :bold, :colspan => 3 }, { :content => 'Case number<br/>of other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 }, { :content => 'Approximate date<br/>of last order in other<br/>proceeding(s)', :align => :center, :font_style => :bold, :rowspan => 2, :width => 108 } ]
      table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 } ]
      table_row [ '1. ', '', '', '', '' ]
      table_row [ '... ', '', '', '', '' ]
      push_table 1

      move_down
      push_header 'If children were involved (other than those listed on front page), please provide:', 10
      table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Date of birth', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Relationship', :align => :center, :font_style => :bold, :width => 108 } ]
      table_row [ '1. ', '', '', '', '' ]
      table_row [ '... ', '', '', '', '' ]
      push_table

      move_down
      push_header 'Children involved in this case', 10
      table_row [ { :content => 'First name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Last name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Middle name', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Date of birth', :align => :center, :font_style => :bold, :width => 108 }, { :content => 'Relationship', :align => :center, :font_style => :bold, :width => 108 } ]
      table_row [ '1. ', '', '', '', '' ]
      table_row [ '... ', '', '', '', '' ]
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