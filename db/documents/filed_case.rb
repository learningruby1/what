Template.where( :name => 'Filed Case /<spain/>Caso archivado').first.try :destroy
template = Template.create :name => 'Filed Case /<spain/>Caso archivado', :description => 'No description /<spain/>No hay descripción' if !template.present?

step_number = 0

current_step = template.steps.create :step_number => step_number += 1,#1
                                     :title => 'ENTER INFORMATION /<spain/>ESCRIBA LA INFORMACIÓN'
toggle_id = 0
toggle_id += 1
#Correct Spain hints
current_step.fields.create :name => 'Enter the Case # /<spain/>Escriba el # del Caso *', :mandatory => { :value => /^\d+/, :hint => 'Enter correct # /<spain/>Escriba #' }, :field_type => 'string'
current_step.fields.create :name => 'Enter the Dept.: /<spain/>Escriba el Departamento: *', :mandatory => { :value => /^\d+/, :hint => 'Enter correct Dept /<spain/>Escriba ' }, :field_type => 'string'

current_step.fields.create :field_type => 'text', :name => 'Date of filing, you will find this information usually on the right side corner. <br/><spain/>Fecha de archivo,  usted encontrará esta información normalmente en la esquina derecha.', :toggle_id => toggle_id

current_step.fields.create :name => 'Summons and Complaint /<spain/>Citatorio y Demanda: *', :field_type => 'date', :mandatory => { :value => /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/, :hint => 'Please enter a /<spain/>Por favor, ' }
current_step.fields.create :name => 'Preliminary Injunction /<spain/>Precautoria Conjunta *', :field_type => 'date', :mandatory => { :value => /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/, :hint => 'Please enter a /<spain/>Por favor, ' }



toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1,#2
                                     :title => 'PERSON WHO WILL SERVE (insert name of defendant) /<spain/>PERSONA QUE ENTREGARA LOS DOCUMENTOS (insert name of defendant) '

current_step.fields.create :field_type => 'text', :name => 'Do you have a current address for (insert name of opposing party)? /<spain/>¿Tiene una dirección actual para (insert name of opposing party)?'
current_step.fields.create :field_type => 'radio', :name => 'No<option/>Yes /<spain/>Sí', :toggle_id => toggle_id, :mandatory => { :value => /\w+/, :hint => 'Please select one /<spain/>Seleccione uno, por favor' }

current_step.fields.create :field_type => 'text', :name => 'Who is going to give (insert name of opposing party) the documents? <br/><spain/>¿Quién le va a dar los documentos a  (insert name of opposing party)?', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'radio', :name => '(insert the name of defendant) will accept and sign for the documents. /<spain/>(insert the name of defendant) va a aceptar y firmar los documentos.
                                                             <option/>I have a friend/Family member /<spain/>Tengo un amigo/familiar
                                                             <option/>I will hire a private processor /<spain/>Voy a contratar un procesador privado', :toggle_id => toggle_id, :toggle_option => 'Yes', :mandatory => { :value => /\w+/, :hint => 'Please select one /<spain/>Seleccione uno, por favor' }

