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

current_step.fields.create :field_type => 'text', :name => 'Date of filing, you will find this information usually on the right side corner. <br/><spain/>Fecha de archivo,  usted encontrará esta información normalmente en la esquina derecha.'

toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Summons and Complaint /<spain/>Citatorio y Demanda: *', :toggle_id => toggle_id
current_step.fields.create :name => '', :field_type => 'date', :toggle_id => toggle_id, :toggle_option => 'Summons'
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Preliminary Injunction /<spain/>Precautoria Conjunta *', :toggle_id => toggle_id
current_step.fields.create :name => '', :field_type => 'date', :toggle_id => toggle_id, :toggle_option => 'Preliminary'


toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1,#2
                                     :title => 'PERSON WHO WILL SERVE <defendant_full_name> /<spain/>PERSONA QUE ENTREGARA LOS DOCUMENTOS <defendant_full_name_spain> '

current_step.fields.create :field_type => 'text', :name => 'Do you have a current address for <defendant_full_name>? /<spain/>¿Tiene una dirección actual para <defendant_full_name_spain>?'
addres_field = current_step.fields.create :field_type => 'radio', :name => 'No<option/>Yes /<spain/>Sí', :toggle_id => toggle_id, :mandatory => { :value => /\w+/, :hint => 'Please select one /<spain/>Seleccione uno, por favor' }



current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => addres_field.id, :render_if_field_value => 'Yes' #3
current_step.fields.create :field_type => 'text', :name => 'Who is going to give <defendant_full_name> the documents? <br/><spain/>¿Quién le va a dar los documentos a <defendant_full_name_spain>?'

current_step.fields.create :field_type => 'radio', :name => '<defendant_full_name> will accept and sign for the documents. /<spain/><defendant_full_name_spain> va a aceptar y firmar los documentos.
                                                             <option/>I have a friend/Family member /<spain/>Tengo un amigo/familiar
                                                             <option/>I will hire a private processor /<spain/>Voy a contratar un procesador privado', :toggle_id => toggle_id, :mandatory => { :value => /\w+/, :hint => 'Please select one /<spain/>Seleccione uno, por favor' }

current_step.fields.create :field_type => 'text', :name => 'Enter information about person who is going to give te documents', :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'Name /<spain/>Nombre: *', :mandatory => { :value => /^[a-zA-Z\- ]+$/, :hint => 'Enter name /<spain/>Escriba el nombre' }, :field_type => 'string-upcase', :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'Middle Initial /<spain/>Inicial del Segundo Nombre:', :field_type => 'string-upcase', :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'Last Name /<spain/>Apellido: *', :mandatory => { :value => /^[a-zA-Z\- ]+$/, :hint => 'Enter last name /<spain/>Escriba el apellido' }, :field_type => 'string-upcase', :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'Home Address /<spain/>Dirección de casa: *', :mandatory => { :value => /^([0-9a-zA-Z\-,.\/ #]+)?$/, :hint => 'Please enter a valid home address /<spain/>Por favor, ponga una dirección de casa o postal válida' }, :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'City /<spain/>Ciudad: *', :mandatory => { :value => /\w+/, :hint => 'Provide a city /<spain/>Por favor, proporciona una ciudad' }, :field_type => 'string-capitalize', :toggle_id => toggle_id, :toggle_option => 'I have'
current_step.fields.create :name => 'Zip Code /<spain/>Código postal: * ', :mandatory => { :value => /^\w+$/, :hint => 'Please enter a valid zip code /<spain/>Por favor, ponga un código postal válido' }, :toggle_id => toggle_id, :toggle_option => 'I have'