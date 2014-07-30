module PdfDocument
  class DivorceInjunction < DivorceWrapper
    def generate
      push_text 'cc12'

      push_header "#{ @clark_nye == 'Clark' ? '8' : '5' }th JUDICIAL DISTRICT COURT"
      push_header "#{ @clark_nye } JUDICIAL DISTRICT COURT"
      move_down 40

      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name } Plaintiff,<br/>vs.<br/>#{ @defendant_first_name } #{ @defendant_middle_name } #{ @defendant_last_name } Defendant", :width => 300, :font_style => :bold }, { :content => "Case  No #{ '_'*20 }<br/><br/>Dept. No #{ '_'*20 }", :width => 240 } ]
      push_table -1, 0
      move_down 30
      push_header '<b>JOINT PRELIMINARY INJUNCTION</b>'
      move_down 15

      push_text '<b>NOTICE!  THIS INJUNCTION IS EFFECTIVE UPON THE PARTY REQUESTING SAME WHEN ISSUED AND AGAINST THE OTHER PARTY WHEN SERVED.  THIS INJUNCTION SHALL REMAIN IN EFFECT FROM THE TIME OF ITS ISSUANCE UNTIL TRIAL OR UNTIL DISSOLVED OR MODIFIED BY THE COURT.  DISOBEDIENCE OF THIS INJUNCTION IS PUNISHABLE BY CONTEMPT.</b>'
      move_down 20
      push_text '<b>TO: Plaintiff and Defendant:</b>'

      move_down
      push_text '<b>YOU ARE HEREBY PROHIBITED AND RESTRAINED FROM:</b>', @text_indent
      move_down
      push_text '1. Transferring, encumbering, concealing, selling or otherwise disposing of any of your', @text_indent
      push_text 'joint, common or community property, except in the usual course of business or for ', @text_indent + 15
      push_text 'the necessities of life, without the written consent of the parties or the permission of the.', @text_indent + 15
      push_text 'court.', @text_indent + 15
      move_down
      push_text '2. Molesting, harassing, disturbing the peace or committing an assault or battery upon', @text_indent
      push_text 'your spouse or your child or step-child.', @text_indent + 15
      move_down
      push_text '3. Removing any child of the parties then residing in the state of Nevada with an intent', @text_indent
      push_text 'or effect to deprive the court of jurisdiction as to said child without the prior written', @text_indent + 15
      push_text 'consent of the parties or the advance permission of the court.', @text_indent + 15

      clerk_or_judge  = @clark_nye == 'Clark' ? 'CLERK OF COURT' : 'JUDGE'
      deputy_or_judge = @clark_nye == 'Clark' ? 'Deputy Clerk' : 'Judge'

      move_down 40
      table_row [ { :content => 'Submitted by:', :width => 300 }, { :content => clerk_or_judge, :width => 240 } ]
      table_row [ { :content => '_'*35, :width => 300 }, { :content => '_'*35, :width => 240 } ]
      table_row [ { :content => 'Signature', :width => 300 }, { :content => deputy_or_judge, :width => 240 } ]
      table_row [ { :content => "#{ @plaintiff_first_name } #{ @plaintiff_middle_name } #{ @plaintiff_last_name }", :width => 300 }, { :content => "#{  }", :width => 240 } ]
      push_table -1, 0

      finishing
    end
  end
end