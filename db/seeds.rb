template = Template.create :name => 'Complaint for Divorce', :description => 'No description'

current_step = template.steps.create :step_number => 1,
                                     :title => 'Your information / Su informatión',
                                     :description => 'Since you are the person starting the divorce action, you will be referred as the PLAINTIFF.<br/>Ya que usted es la persona que inicia la acción de divorcio, usted será referido como el demandante (PLAINTIFF)'

current_step.fields.create :name => 'Name / Nombre: *'
current_step.fields.create :mandatory => false, :name => 'Middle Initial / Inicial de Segundo Nombre:'
current_step.fields.create :name => 'Last Name / Apellido: *'

current_step.fields.create :in_line => true, :name => 'Date of Birth / Fecha de nacimiento: *'
current_step.fields.create :in_line => true
current_step.fields.create :in_line => true

current_step.fields.create :mandatory => false, :name => 'Social Security # / Seguro Social #:'
current_step.fields.create :name => 'Mailing Address / Dirección de casa o postal: *'
current_step.fields.create :name => 'City / Ciudad: *'
current_step.fields.create :name => 'State / Estado: *'
current_step.fields.create :name => 'Zip Code / Código postal: *'


current_step = template.steps.create :step_number => 2,
                                     :title => 'Your Spouse\'s Information / Informatión de su esposa(o)',
                                     :description => 'This person will be referred as the DEFENDANT<br/>Esta persona serà referida como el demandado (DEFENDANT)'

current_step.fields.create :name => 'Name / Nombre: *'
current_step.fields.create :mandatory => false, :name => 'Middle Initial / Inicial de Segundo Nombre:'
current_step.fields.create :name => 'Last Name / Apellido: *'

current_step.fields.create :in_line => true, :name => 'Date of Birth / Fecha de nacimiento: *'
current_step.fields.create :in_line => true
current_step.fields.create :in_line => true

current_step.fields.create :mandatory => false, :name => 'Social Security # / Seguro Social #:'
current_step.fields.create :name => 'Mailing Address / Dirección de casa o postal: *'
current_step.fields.create :name => 'City / Ciudad: *'
current_step.fields.create :name => 'State / Estado: *'
current_step.fields.create :name => 'Zip Code / Código postal: *'
current_step.fields.create :name => 'Email / Correo Electrónico: *'
current_step.fields.create :name => 'Phone number / Núnero de teléfono:'


current_step = template.steps.create :step_number => 3,
                                     :title => 'Spousal Support / Manutención de Esposa(o)',
                                     :description => 'Are you requesting spousal support?<br/>¿Usted está solicitando manutención de esposa(o)?'

current_step.fields.create :mandatory => false, :field_type => 'radio', :name => 'No'
current_step.fields.create :mandatory => false, :field_type => 'radio', :name => 'Yes/Si'
current_step.fields.create :mandatory => false, :field_type => 'radio', :name => 'I will pay support'

#TODO mandatory to below
current_step = template.steps.create :step_number => 4,
                                     :title => 'Reason for divorce / Razón por el divorcio',
                                     :description => 'Nevada is a "no fault" divorce state. This means the person seeking the divorce does not habe to prove in court that she or he is entitled to a divorce.<br/>Nevada es un estado de divorcio "sin culpa". Esto significa que la persona que busca el divorcio no tiene que probar en la corte que él o ella tiene el derecho a divorciarse.'

current_step.fields.create :field_type => 'radio', :name => 'We NO LONGER want to be married. / Ta NO QUEREMOS estar casados'
current_step.fields.create :field_type => 'radio', :name => 'We have LIVED SEPARATED and apart for ever 1 year. / Hemos VIVIDO SEPARADO por más de 1 año'


current_step = template.steps.create :step_number => 5,
                                     :title => 'Property / Bienes',
                                     :description => 'Nevada is a community property state. This means that the law presumes that all property (bank account, 401K, house, car, furniture, jewelry, etc.) acquired or incurred during the marriage is community property, and belongs equally to both parties, with the exception of separate property.<br/>Nevada es un estado de propiedad comunitaria. Esto significa que la Ley presupone que todos las propiedades (cuenta bancaria, 401 k, casa, carro, muebles, joyria, etc) adquirida o comprados durante el matrimonio son bienes comunitarios y pertenece igualmente a ambas partes, con la excepción de propiedad individual.<br/><br/>Do you have community property to divide? / ¿Tienen propiedad en común que dividir?'

current_step.fields.create :field_type => 'radio', :name => 'Yes / Si'
current_step.fields.create :field_type => 'radio', :name => 'No'


current_step = template.steps.create :step_number => 6,
                                     :title => 'Pets / Mascotas',
                                     :description => 'Do you have pets that you would like the court give you custody of?<br/>¿Va a pedir la custodia de su mascota en la corte?'

current_step.fields.create :field_type => 'radio', :name => 'Yes / Si'
current_step.fields.create :field_type => 'radio', :name => 'No'


current_step = template.steps.create :step_number => 7,
                                     :title => 'Spousal support amount / Cantidad de Manutención de Esposa(o)',
                                     :description => 'For example, I want my spouse to me spousal support of $500 per month for 5 years.<br/>Ejemplo, yo quiero que mi esposo me pague manutencion de $500 por mes por 5 años.'

current_step.fields.create :name => 'I want spousal support $ / Yo quiero manutención en la cantidad de $<br/>Enter Amount'
current_step.fields.create :name => 'per month for / por mes por<br/> Enter the number / Ponga ek numbero'
current_step.fields.create :field_type => 'radio', :name => 'month/mese'
current_step.fields.create :field_type => 'radio', :name => 'years/ańos'



current_step = template.steps.create :step_number => 8,
                                     :title => 'Wife`s Name / Cambio de Apollido'

current_step.fields.create :field_type => 'radio', :name => 'Wife NEVER CHANGE her name / Esposa NUNCA SE CAMBIÓ el apellido.'
current_step.fields.create :field_type => 'radio', :name => 'Wife WILL KEEP MARRIED name / Esposa se va a QUEDAR con el apellido de casada.'
current_step.fields.create :field_type => 'radio', :name => 'Wife WILL RETURN to her maide name / Esposa VOLVERA a su apellido de soltera que.'


current_step = template.steps.create :step_number => 9,
                                     :title => 'Debts / Deudas',
                                     :description => 'Nevada is a community propert state. This means that the law presumes that all debts (credit cards, loans, mortgage, taxes, hospital bills, etc) acquired or incurred durring the marriage is community debts, and belongs equally to both parties, with the exception of separate debt.<br/>Nevada es un estado de propiedad comunitaria. Esto significa qie la Ley preupone que todas las deudas (tarjetas de crédito, préstamos, taxes, cuenta de hospital, etc.) adquiridas o incurridas durante el matrimonio son deudas y pertenece igualmente a ambas partes, con la excepción de deudas individuales.<br/>Dou you have community debts to divide?<br/>¿Tienen deudas en común que dividir?'

current_step.fields.create :field_type => 'radio', :name => 'Yes / Si'
current_step.fields.create :field_type => 'radio', :name => 'No'


current_step = template.steps.create :step_number => 10,
                                     :title => 'Pregnancy / Embarazada',
                                     :description => 'To my knowledge wife / A mi  conociemiento la esposa'

current_step.fields.create :field_type => 'radio', :name => 'IS NOT currently pregnant / NO ESTÁ embarazada en este momento.'
current_step.fields.create :field_type => 'radio', :name => 'IS currently pregnant. / ESTÁ embarazada en este momento.'


current_step = template.steps.create :step_number => 11,
                                     :title => 'Spousal support amount / Cantidad de Manutención de Esposa(o)',
                                     :description => 'For example, I will pay my spouse to me spousal support of $500 per month for 5 years.<br/>Ejemplo, yo le pagare a mi esposo me pague manutencion de $500 por mes por 5 años.'

current_step.fields.create :in_line => true, :name => 'I WILL PAY spousal support $ / Yo PAGARE manutención en la cantidad de $<br/>Enter Amount'
current_step.fields.create :in_line => true, :name => 'per month for / por mes por<br/> Enter the number / Ponga ek numbero'
current_step.fields.create :field_type => 'radio', :name => 'month/mese'
current_step.fields.create :field_type => 'radio', :name => 'years/ańos'


current_step = template.steps.create :step_number => 12,
                                     :title => 'Children / Menores',
                                     :description => 'Are there children born or legally adopteed of this marriage UNDER the age of 18?<br/>¿Hay menores de 18 años nacidos o adoptados legalmente de este matrimonio?'

current_step.fields.create :field_type => 'radio', :name => 'Yes / Si'
current_step.fields.create :field_type => 'radio', :name => 'No'