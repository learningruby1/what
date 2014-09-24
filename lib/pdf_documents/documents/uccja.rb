module PdfDocument
  class Uccja < DivorceWrapper
    def generate
      _counter = 0
      default_leading 5
      push_text 'CC13', :style => :bold

      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }"
      push_text "#{ @plaintiff_mailing_addres }"
      push_text "#{ @plaintiff_home_address_city }, #{ @plaintiff_home_address_state } #{ @plaintiff_home_address_zip }"

      push_text "#{ @plaintiff_phone }"
      push_text "#{ @plaintiff_email }"
      push_text 'Self-Represented', :style => :bold

      move_down 30
      push_header "IN THE #{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT OF THE"
      push_header "STATE OF NEVADA, IN AND FOR THE COUNTY OF #{ @clark_nye.upcase }"
      move_down 20


      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }<br/>Plaintiff,<br/><br/>vs.<br/><br/>#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name }<br/>Defendant.<br/>#{ '_'*20 }", :width => 300, :font_style => :bold, :border_width => 0 },
                  { :content => "<br/>CASE  NO.: #{@case.to_s}<br/><br/><br/>DEPT NO.: #{@dept.to_s}", :width => 240, :border_width => 0  } ]
      push_table -1, 0

      default_leading 8
      move_down 20
      push_header '<b>DECLARATION UNDER UNIFORM CHILD CUSTODY JURISDICTION ENFORCEMENT ACT (NRS 125A.385)'
      move_down 20
      push_text "1. There #{ @number_of_children > 1 ? "are #{@number_of_children} children" : 'is 1 child' } of the parties subject to this proceeding. The name, place of birth, birth date and sex of each child, present address, periods of residence and places where each child has lived within the last (5) five years, and the name(s), present address and relationship to the child of each person with whom the child has lived during that time are: "


      table_row [ { :content =>"1. Child’s Name", :width => 150 }, { :content =>"Place of Birth", :width => 170 }, { :content =>"Birth Date", :width => 120 }, { :content =>"Sex", :width => 100 } ]
      table_row [ { :content =>"NAME MIDDLE LAST", :width => 150 }, { :content =>"CHINA, HONCONG", :width => 170 }, { :content =>"1/1/2000", :width => 120 }, { :content =>"Female", :width => 100 } ]
      table_row [ { :content =>"Period of Residence", :width => 150 }, { :content =>"Address", :width => 170 }, { :content =>"Person Child lived with", :width => 120 }, { :content =>"Relationship", :width => 100 } ]
      table_row [ { :content =>"(insert) to Present", :width => 150 }, { :content =>"(insert)", :width => 170 }, { :content =>"(insert)", :width => 120 }, { :content =>"(insert)", :width => 100 } ]
      table_row [ { :content =>"To (insert)", :width => 150 }, { :content =>"(insert)", :width => 170 }, { :content =>"(insert)", :width => 120 }, { :content =>"(insert)", :width => 100 } ]
      push_table -1, 0
      move_down 40

      push_text "2. I (insert HAVE or HAVE NOT bold) participated as a party, witness, or in any other capacity in any other litigation or custody proceeding in this or any other state concerning custody of a child involved in this proceeding.", @text_indent
      push_text "a. Name of each child involved: ( insert name of child )", @text_indent * 2
      push_text "b. Your role in other proceeding: (insert their answer)", @text_indent * 2
      push_text "c. Court, state, and case number of other proceeding: (insert their answer )", @text_indent * 2
      push_text "d. Date of court order or judgment in other proceeding: (insert their answer )", @text_indent * 2

      push_text "3. I (insert DO or DO NOT (bold)) know of any proceeding that could affect the current proceeding including proceedings for enforcement and proceedings related to domestic violence, protective orders, termination of parental rights and adoptions pending in a court of this or any other state concerning a child involved in this proceeding other than that set out in item 1 above.", @text_indent
      push_text "a. Name of each child involved: ( insert name of child )", @text_indent * 2
      push_text "b. Your role in other proceeding: (insert their answer)", @text_indent * 2
      push_text "c. Court, state, and case number of other proceeding: (insert their answer )", @text_indent * 2
      push_text "d. Date of court order or judgment in other proceeding: (insert their answer )", @text_indent * 2

      push_text "4. I (insert DO or DO NOT (bold) know of any person not a party to this proceeding who has physical custody or claims to have custody or visitation rights with respect to any child subject to this proceeding.", @text_indent
      push_text "a.  Name and address of person: ((insert their answer )", @text_indent * 2
      push_text "(insert selection by user ) Person named has physical custody of (insert name of child)", @text_indent * 3
      push_text "Person named claims custody right as to (insert name of child)", @text_indent * 3
      push_text "Person named claims visitation rights with (insert name of child)", @text_indent * 3

      push_text "5. I have a continuing duty to inform the court of any proceeding in this or any other state that could affect the current proceeding and will provide updated information to the court.", @text_indent

      move_down 40
      push_text 'DATED THIS_______day of ___________, 20___.'
      default_leading 2
      push_text '______________________'
      push_text "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name } Signature"

      push_text '<b>I declare under penalty of perjury under the law of the State of Nevada that the foregoing is true and correct.', @text_indent

      table_row [ { :content => "Signed on: #{'_'*35}", :width => 300, :border_width => 0  },
                  { :content => "#{'_'*35}<br/> #{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }<br/>Signature", :width => 240, :border_width => 0  } ]
      push_table -1, 0

      finishing
    end
  end
end













