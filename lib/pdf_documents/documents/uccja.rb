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


      @number_of_children.times do |i|
        table_row [ { :content => "#{i+1}. Child’s Name", :width => 150, :font_style => :bold }, { :content => "Place of Birth", :width => 170, :font_style => :bold },                                                            { :content => "Birth Date", :width => 120, :font_style => :bold },     { :content => "Sex", :width => 100, :font_style => :bold } ]
        table_row [ { :content => @children_names[i], :width => 150 },                           { :content => "#{@children_info[i][:city].to_s} #{@children_info[i][:state].to_s} #{@children_info[i][:country].to_s}", :width => 170 }, { :content => @children_info[i][:date_of_birth].to_s, :width => 120 }, { :content => @children_info[i][:sex].to_s, :width => 100 } ]

        table_row [ { :content =>"Period of Residence", :width => 150, :font_style => :bold }, { :content =>"Address", :width => 170, :font_style => :bold }, { :content =>"Person Child lived with", :width => 120, :font_style => :bold }, { :content =>"Relationship", :width => 100, :font_style => :bold } ]
        table_row [ { :content =>"(insert) to Present", :width => 150 }, { :content =>"(insert)", :width => 170 }, { :content =>"(insert)", :width => 120 }, { :content =>"(insert)", :width => 100 } ]
        table_row [ { :content =>"To (insert)", :width => 150 }, { :content =>"(insert)", :width => 170 }, { :content =>"(insert)", :width => 120 }, { :content =>"(insert)", :width => 100 } ]
      end
      push_table -1, 0
      move_down 40

      @number_of_children.times do |i|
        if @children_info.select { |e| e[:question_1_case_count] }.empty?
          push_text "2. I <b>HAVE NOT</b> participated as a party, witness, or in any other capacity in any other litigation or custody proceeding in this or any other state concerning custody of a child involved in this proceeding.", @text_indent
        else
          push_text "2. I <b>HAVE</b> participated as a party, witness, or in any other capacity in any other litigation or custody proceeding in this or any other state concerning custody of a child involved in this proceeding.", @text_indent
        end
        @children_info[i][:question_1_case_count].to_i.times do |j|
          push_text "a. Name of each child involved: " + @children_names[i], @text_indent * 2
          push_text "b. Your role in other proceeding: " + @children_info[i][:question_1_cases][j][:role].to_s, @text_indent * 2
          push_text "c. Court, state, and case number of other proceeding: #{@children_info[i][:question_1_cases][j][:name_of_court].to_s} #{@children_info[i][:question_1_cases][j][:state].to_s} #{@children_info[i][:question_1_cases][j][:case_number].to_s}", @text_indent * 2
          push_text "d. Date of court order or judgment in other proceeding: " + @children_info[i][:question_1_cases][j][:date].to_s, @text_indent * 2
        end

        if @children_info.select { |e| e[:question_2_case_count] }.empty?
          push_text "3. I <b>DO NOT</b> know of any proceeding that could affect the current proceeding including proceedings for enforcement and proceedings related to domestic violence, protective orders, termination of parental rights and adoptions pending in a court of this or any other state concerning a child involved in this proceeding other than that set out in item 1 above.", @text_indent
        else
          push_text "3. I <b>DO</b> know of any proceeding that could affect the current proceeding including proceedings for enforcement and proceedings related to domestic violence, protective orders, termination of parental rights and adoptions pending in a court of this or any other state concerning a child involved in this proceeding other than that set out in item 1 above.", @text_indent
        end
        @children_info[i][:question_2_case_count].to_i.times do |j|
          push_text "a. Name of each child involved: " + @children_names[i], @text_indent * 2
          push_text "b. Your role in other proceeding: " + @children_info[i][:question_2_cases][j][:role].to_s, @text_indent * 2
          push_text "c. Court, state, and case number of other proceeding: #{@children_info[i][:question_2_cases][j][:name_of_court].to_s} #{@children_info[i][:question_2_cases][j][:state].to_s} #{@children_info[i][:question_2_cases][j][:case_number].to_s}", @text_indent * 2
          push_text "d. Date of court order or judgment in other proceeding: " + @children_info[i][:question_2_cases][j][:date].to_s, @text_indent * 2
        end

        if @children_info.select { |e| e[:question_3_case_count] }.empty?
          push_text "4. I <b>DO NOT</b> know of any person not a party to this proceeding who has physical custody or claims to have custody or visitation rights with respect to any child subject to this proceeding.", @text_indent
        else
          push_text "4. I <b>DO</b> know of any person not a party to this proceeding who has physical custody or claims to have custody or visitation rights with respect to any child subject to this proceeding.", @text_indent
        end
        @children_info[i][:question_3_case_count].to_i.times do |j|
          push_text "a. Name and address of person: #{@children_info[i][:question_3_cases][j][:name].to_s} #{@children_info[i][:question_3_cases][j][:address].to_s}", @text_indent * 2
          case @children_info[i][:question_3_cases][j][:rights]
          when /VISITATION/
            push_text "Person named claims visitation rights with " + @children_names[i], @text_indent * 3
          when /CUSTODY/
            push_text "Person named claims custody right as to " + @children_names[i], @text_indent * 3
          when /PHYSICAL/
            push_text "Person named has physical custody of " + @children_names[i], @text_indent * 3
          end
        end
      end

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