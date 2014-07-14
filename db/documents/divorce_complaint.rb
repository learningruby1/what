Template.where( :name => 'Complaint for Divorce').first.try :destroy
template = Template.create :name => 'Complaint for Divorce', :description => 'No description' if !template.present?

step_number = 0

current_step = template.steps.create :step_number => step_number += 1,#0
                                     :title => 'Are you filing in Clark County or Nye County?'

current_step.fields.create :name => 'Clark
                                     <option/>Nye', :mandatory => false, :field_type => 'radio'


current_step = template.steps.create :step_number => step_number += 1,#1
                                     :title => 'Your information /<spain/>Su Información'

current_step.fields.create :name => 'Name /<spain/>Nombre: *'
current_step.fields.create :name => 'Middle Initial /<spain/>Inicial de Segundo Nombre:', :mandatory => false
current_step.fields.create :name => 'Last Name /<spain/>Apellido: *'
current_step.fields.create :name => 'Date of Birth /<spain/>Fecha de nacimiento: *', :field_type => 'date'
current_step.fields.create :name => 'Social Security # /<spain/># Seguro Social:', :mandatory => false
current_step.fields.create :name => 'Mailing Address /<spain/>Dirección de casa o postal: *'
current_step.fields.create :name => 'City /<spain/>Ciudad: *'
current_step.fields.create :name => 'Email /<spain/>Correo Electrónico: *'
current_step.fields.create :name => 'State /<spain/>Estado: *'
current_step.fields.create :name => 'Zip Code /<spain/>Código postal: *'
current_step.fields.create :name => 'Phone number /<spain/>Número de teléfono:', :mandatory => false
current_step.fields.create :name => 'I am Wife /<spain/>Usted es Esposa
                                     <option/>I am Husband /<spain/>Usted es Esposo', :mandatory => false, :field_type => 'radio'
current_step.fields.create :name => 'Since you are the person starting the divorce action, you will be referred as the PLAINTIFF.
                                     <br/><spain/>Ya que usted es la persona que inicia la acción de divorcio, usted será referido como el demandante (PLAINTIFF)', :field_type => 'text'


current_step = template.steps.create :step_number => step_number += 1,#2
                                     :title => 'Your Spouse\'s Information /<spain/>Información de su esposa(o)',
                                     :description => 'This person will be referred as the DEFENDANT<br/><spain/>Esta persona serà referida como el demandado (DEFENDANT)'

current_step.fields.create :name => 'Name /<spain/>Nombre: *'
current_step.fields.create :name => 'Middle Initial /<spain/>Inicial de Segundo Nombre:', :mandatory => false
current_step.fields.create :name => 'Last Name /<spain/>Apellido: *'
current_step.fields.create :name => 'Date of Birth /<spain/>Fecha de nacimiento: *', :field_type => 'date'
current_step.fields.create :name => 'Social Security # /<spain/># Seguro Social:', :mandatory => false
current_step.fields.create :name => 'Mailing Address or last Known address /<spain/> Dirección postal o última dirección : *'
current_step.fields.create :name => 'City /<spain/>Ciudad: *'
current_step.fields.create :name => 'State /<spain/>Estado: *'
current_step.fields.create :name => 'Zip Code /<spain/>Código postal: *'
current_step.fields.create :name => 'Email /<spain/>Correo Electrónico: *'
current_step.fields.create :name => 'Phone number /<spain/>Número de teléfono:', :mandatory => false


toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1,#3
                                     :title => 'Marriage Information /<spain/>Información de Matrimonio',
                                     :description => 'Where were you married? /<spain/>¿Dónde se casaron?'

current_step.fields.create :name => 'In the United States /<spain/>En los Estados Unidos
                                     <option/>Outside the United States /<spain/>Fuera de los Estados Unidos', :toggle_id => toggle_id, :mandatory => false, :field_type => 'radio'
current_step.fields.create :name => 'City /<spain/>Ciudad: *', :toggle_id => toggle_id, :toggle_option => 'In the United States', :mandatory => false
current_step.fields.create :name => 'State /<spain/>Estado: *', :toggle_id => toggle_id, :toggle_option => 'In the United States', :mandatory => false
current_step.fields.create :name => 'City/Town/Province: /<spain/>Ciudad/Pueblo/Provincia: *', :toggle_id => toggle_id, :toggle_option => 'Outside', :mandatory => false
current_step.fields.create :name => 'Country /<spain/>País: *', :toggle_id => toggle_id, :toggle_option => 'Outside', :mandatory => false
current_step.fields.create :name => 'Marriage Date /<spain/>Fecha de matrimonio:', :field_type => 'date'
current_step.fields.create :name => 'Don’t remember the date? Got married in Clark County? Click here<br/><spain/>¿No recuerda la fecha? ¿Se casó en el Condado de Clark? Haz clic', :field_type => 'link:sep:https://recorder.co.clark.nv.us/RecorderEcommerce/', :mandatory => false


current_step = template.steps.create :step_number => step_number += 1,#4
                                     :title => 'Nevada Residency/ Residente de Nevada',
                                     :description => 'The party filing for divorce must be a Nevada resident for at least six weeks before the filing date.<br/>
                                                      A resident witness will need to sign an affidavit stating your residency in Nevada (relatives are allowed).<br/>
                                                      <spain/>Si usted es la persona que está presentando el divorcio, debe ser residente de Nevada por lo menos 6 semanas antes de archivar la demanda de divorcio.<br/>
                                                      El testigo de residencia deberá firmar una declaración jurada indicando que usted es residente de Nevada (se permiten familiares).'

current_step.fields.create :name => 'I have lived in Nevada for over 6 weeks.
                                     <br/><spain/>Yo, he vivido en Nevada por más de 6 semanas.', :field_type => 'text'
current_step.fields.create :name => 'Since when? /<spain/>¿Desde cuándo?', :field_type => 'date'


current_step = template.steps.create :step_number => step_number += 1,#5
                                     :title => 'Pregnancy /<spain/>Embarazada',
                                     :description => 'To my knowledge wife /<spain/>A mi  conocimiento la esposa'

current_step.fields.create :field_type => 'radio', :name => 'IS NOT currently pregnant /<spain/>NO ESTÁ embarazada en este momento.
                                                             <option/>IS currently pregnant. /<spain/>ESTÁ embarazada en este momento.'


current_step = template.steps.create :step_number => step_number += 1,#6
                                     :title => 'Children /<spain/>Menores',
                                     :description => 'Are there children born or legally adopted of this marriage UNDER the age of 18?<br/><spain/>¿Hay menores de 18 años nacidos o adoptados legalmente de este matrimonio?'

children_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                              <option/>No'


toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#7
                                     :title => 'Children\'s Residency /<spain/>Residencia de los menores',
                                     :description => 'Children must have resided in Nevada for a minimum of 6 months before the Nevada District Court will take jurisdiction over them.<br/>
                                                      Have the child(ren) lived in Nevada for over 6 months?<br/>
                                                      <spain/>Los menores deben haber vivido en Nevada por un mínimo de 6 meses antes  que la corte de Nevada tenga el poder judicial sobre ellos.<br/>
                                                      ¿Han vivido los menores en Nevada por más de 6 meses?'

children_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                              <option/>No', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Nevada Court does not have the legal right to set
                                                            custody at this time, BUT you can still get a divorce
                                                            without custody.
                                                            <br/><spain/>La corte de Nevada no tiene el poder para establecer
                                                            custodia en este momento, PERO usted todavía puede
                                                            divorciarse sin custodia.', :toggle_id => toggle_id, :toggle_option => 'No'




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#8
                                     :title => 'Number of children /<spain/>Número de menores'

current_step.fields.create :field_type => 'text', :name => 'How many minor children were born or legally adopted during this marriage?
                                                            <br/><spain/>¿Cuántos  menores nacieron o fueron adoptados legalmente durante este matrimonio?'
children_amount_field = current_step.fields.create :field_type => 'amount'



current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes', :amount_field_id => children_amount_field.id,#9
                                     :title => 'Child’s or children’s Information/ Información del Menor or de los menores'

current_step.fields.create :name => 'Name /<spain/>Nombre: *'
current_step.fields.create :mandatory => false, :name => 'Middle Initial /<spain/>Inicial de Segundo Nombre:'
current_step.fields.create :name => 'Last Name /<spain/>Apellido: *'
current_step.fields.create :field_type => 'date', :name => 'Date of Birth /<spain/>Fecha de nacimiento: *'
current_step.fields.create :mandatory => false, :name => 'Social Security # /<spain/># Seguro Social:'
current_step.fields.create :name => 'Son /<spain/>Hijo
                                     <option/>Daughter /<spain/>Hija', :field_type => 'radio'



current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes', #:amount_field_id => children_amount_field.id,#10
                                     :title => 'Legal Custody /<spain/>Custodia Legal',
                                     :description => 'Legal Custody: the right of the parents to make legal decision for the child regarding education, health care, religion, etc. for the welfare of the child.
                                                      <br/>Who will have legal custody of the child(ren)?
                                                      <br/><spain/>Custodia legal: el derecho de los padres para tomar decisiones legales acerca del menor en cuanto a la educación, salud, religión, etc. para el bienestar del menor.<br/>
                                                      ¿Quién tendrá la custodia legal de los menores?'

current_step.fields.create :field_type => 'radio', :name => 'Both Parents /<spain/>AMBOS padres
                                                             <option/>Only MOM /<spain/>Solo MAMÁ
                                                             <option/>Only DAD /<spain/>Solo PAPÁ'


current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#11
                                     :title => 'Physical Custody /<spain/>Custodia Física',
                                     :description => 'Select  the type of custody you would like to have:
                                                      <br/><spain/>Seleccione el tipo de custodia que usted desea:'

current_step.fields.create :field_type => 'text', :name => 'PRIMARY PHYSICAL CUSTODY: when the child(ren) live with one parent for most of the time (more than 60%) and has limited visitation with the other parent.<br/>
                                                            <spain/>CUSTODIA FISICA PRIMARIA: cuando los menores viven con un padre/madre más del 60% y el otro padre/madre tiene visitas.'

current_step.fields.create :field_type => 'radio', :name => 'With mom and visits with dad /<spain/>Con mamá y visitas con papá.
                                                             <option/>With dad and visit  with mom /<spain/>Con papá y visitas con mamá.
                                                             <option/>Both Parents /<spain/>Ambos padres'

current_step.fields.create :field_type => 'text', :name => 'JOINT PHYSICAL CUSTODY: when the child(ren) live with both parent 50/50 or 60/40 of the time.<br/>
                                                            <spain/>Custodia FISICA COMPARTIDA: cuando los menores viven con ambos padres 50/50 o 60/40 del tiempo.'


current_step.fields.create :field_type => 'text', :name => 'SOLE PHYSICAL CUSTODY: when the child(ren) live with  one parent.
                                                            <br/><spain/>CUSTODIA FÍSICA ÚNICA : cuando los menores  viven solamente con uno de los padres.'

current_step.fields.create :field_type => 'radio', :name => 'Only with the mom /<spain/>Solo conmigo
                                                             <option/>Only with the dad /<spain/>Solo con el OTRO padre'


current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#12
                                     :title => 'Holiday /<spain/>Feriados',
                                     :description => 'Check all the holiday that apply for your child(ren):<br/><spain/>Marque todos los feriados que aplican a su (s) menor (es):'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'New Year’s Eve from /<spain/>Víspera de año nuevo desde', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'New Year’s Day /<spain/>Año Nuevo', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Martin Luther King, Jr. Day /<spain/>Día  de Martin Luther King, Jr.', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'President’s day /<spain/>Día de los Presidentes', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Passover', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Easter /<spain/>Pascua', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Memorial Day', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Mother’s Day /<spain/>Día de la Madre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Other Country Mother’s Day /<spain/>Día de la Madre (de otro país)', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Father’s day /<spain/>Día del Padre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Other Country Father’s Day /<spain/>Día del Padre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#13
                                     :title => 'More Holiday /<spain/>Mas Feriados',
                                     :description => 'Check all the holiday that apply for your child(ren):<br/>
                                                      <spain/>Marque todos los feriados que aplican a su (s) menor (es):'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => '4th of July /<spain/>4 de Julio', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Labor Day /<spain/>Día del trabajador', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Rosh Hashanah /<spain/>Rosh Hashanah', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Yom Kippur', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Nevada Day /<spain/>Día de Nevada', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Halloween', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Veteran’s Day /<spain/>Día de los Veteranos', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Thanksgiving Day /<spain/>Día de Acción de Gracias', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Christmas Eve /<spain/>Víspera de noche de Navidad', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Christmas /<spain/>Navidad', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Father’s Birthday /<spain/>Cumpleaños del Padre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to, with dad every year /<spain/>hasta, con el padre todos los años'


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Mother’s Birthday /<spain/>Cumpleaños de la Madre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to, with mom every year /<spain/>hasta, con la madre todos los años'


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Child’s Birthday /<spain/>Cumpleaños del menor', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Chinese  New Year’s /<spain/>Año Nuevo Chino', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Chanukkah', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Spring Break /<spain/>Vacaciones de primavera', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'all /<spain/>Todo la vacacion
                                                                  <option/>portion /<spain/>porcion de la vacacion con', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                             <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>odd years /<spain/>año  impares
                                                             <option/>even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Winter Break /<spain/>Vacaciones de invierno', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'all /<spain/>Todo la vacacion
                                                                  <option/>portion /<spain/>porcion de la vacacion con', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                             <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>odd years /<spain/>año  impares
                                                             <option/>even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Summer Break /<spain/>Vacaciones de verano', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'all /<spain/>Todo la vacacion
                                                                  <option/>portion /<spain/>porcion de la vacacion con', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                             <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>odd years /<spain/>año  impares
                                                             <option/>even years /<spain/>año pares', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Other Holiday /<spain/>Otro Feriado', :toggle_id => toggle_id
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'from /<spain/>desde'
current_step.fields.create :field_type => 'time', :toggle_id => toggle_id, :name => 'to /<spain/>hasta'
current_step.fields.create :field_type => 'radio-last', :name => 'Mom /<spain/>Madre
                                                                  <option/>Dad /<spain/>Padre', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'every year /<spain/>año
                                                             <option/>every odd years /<spain/>año  impares
                                                             <option/>every even years /<spain/>año pares', :toggle_id => toggle_id


current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#14
                                     :title => 'Children’s Health Insurance /<spain/>Seguro Médico De Los Menores',
                                     :description => 'Who will be responsible for maintaining health and dental insurance for the child(ren)/
                                                      <spain/>¿Quién será responsable de mantener el seguro médico y dental para menor(es)'

current_step.fields.create :field_type => 'radio', :name => 'Mom /<spain/>Mamá
                                                             <option/>Dad /<spain/>Papá
                                                             <option/>Both Parents /<spain/>Ambos Padres'

toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#15
                                     :title => 'Child Support /<spain/>Manutención de menores'

current_step.fields.create :field_type => 'radio', :name => 'No child support /<spain/>No habrá manutención de menores
                                                             <option/>Dad will pay $ /<spain/>El papá pagara $
                                                             <option/>Mom will pay $ /<spain/>La mamá pagara $', :toggle_id => toggle_id

current_step.fields.create :field_type => 'amount', :name => 'per month as child support /<spain/>mensual de manutención para los menores', :toggle_id => toggle_id, :toggle_option => 'will'




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#16
                                     :title => 'Wage withholding /<spain/>Retención de Sueldo'


current_step.fields.create :field_type => 'text', :name => 'Are you requesting wage withholding to collect child support?
                                                            <br/><spain/>¿Está pidiendo retención de salario para cobrar la manutención de los menores?'

current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No'



toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#17
                                     :title => 'Child  Support Arrears /<spain/>Manutención de Menores Retroactiva'


current_step.fields.create :field_type => 'text', :name => 'Are you requesting child support ARREARS?
                                                            <br/><spain/>¿Está solicitando manutención atrasada de menores?'

current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id

current_step.fields.create :field_type => 'date', :name => 'I want back child support starting
                                                            <spain/>Yo QUIERO manutención comenzando', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'date', :name => 'The OTHER parent has paid $ since separation to:
                                                            <spain/>Desde que nos separamos el otro padre me ha dado $ (ponga la cantidad) hasta:', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'You can request up to 4 years
                                                            <br/>I want back child support starting (insert month /year) to (insert month/year).
                                                            The OTHER parent has paid $ since separation.
                                                            <br/><spain/>Puede pedir hasta 4 años atrasados
                                                            <br/>Yo QUIERO manutención comenzando (escriba el mes y año) hasta (escriba el mes y año).
                                                            Desde que nos separamos el otro padre me ha dado $ (ponga la cantidad).', :toggle_id => toggle_id, :toggle_option => 'Yes'

toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => children_field.id, :render_if_field_value => 'Yes',#18
                                     :title => 'Child Tax Exemption /<spain/>Menores en los Impuestos',
                                     :description => 'Who will claim (insert name of child #1) as dependent on tax returns?
                                                      <br/><spain/>¿Quién reclamará (insert name of child #1) como dependiente en los impuestos?'

current_step.fields.create :field_type => 'radio', :name => 'Mom every year /<spain/>Mamá todos los años
                                                             <option/>Dad every year /<spain/>Papá todos los años
                                                             <option/>Dad and Mom alternating years /<spain/>Mamá y Papá  con los años', :toggle_id => toggle_id

current_step.fields.create :field_type => 'date', :name => 'Mom  will start claiming start from and up /<spain/>La mamá comenzara a reclamar a en (ponga el año de comienzo)', :toggle_id => toggle_id, :toggle_option => 'Dad and Mom'


toggle_id = 0
toggle_id += 1
current_step = template.steps.create :step_number => step_number += 1,#19
                                     :title => 'Pet /<spain/>Mascota',
                                     :description => 'Do you have pets that you would like the court to give you custody of?
                                                      <spain/>¿Va a pedir la custodia de sus mascotas en la corte?'

pet_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                         <option/>No', :toggle_id => toggle_id

pet_amount_field = current_step.fields.create :field_type => 'amount', :name => 'How many: /<spain/>Cuántos:', :toggle_id => toggle_id, :toggle_option => 'Yes'




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => pet_field.id, :render_if_field_value => 'Yes', :amount_field_id => pet_amount_field.id,#20
                                     :title => 'Pet Custody /<spain/>Custodia de Mascota'

current_step.fields.create :name => 'Name of your Pet: *
                                     <spain/>Nombre de su mascota:*'

current_step.fields.create :field_type => 'radio', :name => 'Wife will  KEEP /<spain/>Se QUEDARA con la esposa
                                                             <option/>Husband will keep WILL keep /<spain/>Se QUEDARA con el esposo
                                                             <option/>Both Equally /<spain/>AMBOS TENDREMOS custodia '



#
# PROPERTY DIVISION
#


current_step = template.steps.create :step_number => step_number += 1,#21
                                     :title => 'Property /<spain/>Bienes',
                                     :description => 'Nevada is a community property state. This means that the law presumes that all property (bank account, 401K, house, military pension, car, furniture, jewelry, etc.) acquired or incurred during the marriage is community property, and belongs equally to both parties, with the exception of separate property.
                                                      <br/><spain/>Nevada es un estado de propiedad comunitaria.  Esto significa que la ley presupone que todas las propiedades (cuenta bancaria, 401 k, casa, pensión militar, carro, muebles, joyería, etc.) adquiridas o compradas durante el matrimonio son bienes comunitarios y pertenece igualmente a ambas partes, con la excepción de la propiedad individual.'

current_step.fields.create :field_type => 'text', :name => 'Do you have community property to divide?
                                                            <br/><spain/>¿Tienen propiedad en común que dividir?'

property_division_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No
                                                             <option/>No, we already divided them /<spain/>No ya las dividimos'


toggle_id = 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_field.id, :render_if_field_value => 'Yes',#22
                                     :title => 'Property Division: Marital Home /<spain/>División de Propiedad: Casa',
                                     :description => 'Do you have a marital home purchased during the marriage?
                                                      <br/><spain/>¿Tienen usted una casa que compraron durante el matrimonio?'

current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id
current_step.fields.create :name => 'Address /<spain/>Dirección:', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id, :toggle_option => 'Yes'



current_step.fields.create :field_type => 'text', :name => 'Was there more properties bought during the marriage?
                                                            <br/><spain/>¿Compraron más propiedades durante el matrimonio?'

property_division_more_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                                            <option/>No'

toggle_id = 1
current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_more_field.id, :render_if_field_value => 'Yes',#23
                                     :title => 'Property Division: More /<spain/>División de Propiedades: Más',
                                     :description => 'What other property did you buy during the marriage?
                                                      <br/><spain/>¿Qué otra propiedad compraron durante el matrimonio?'

current_step.fields.create :field_type => 'checkbox', :name => 'Home /<spain/>Casa', :toggle_id => toggle_id
current_step.fields.create :name => 'Address /<spain/>Dirección:', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id, :toggle_option => 'Yes'
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Empty land /<spain/>Lote-Tierra', :toggle_id => toggle_id
current_step.fields.create :name => 'Address /<spain/>Dirección:', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id, :toggle_option => 'Yes'
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Business /<spain/>Negocio', :toggle_id => toggle_id
current_step.fields.create :name => 'Address /<spain/>Dirección:', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id, :toggle_option => 'Yes'



current_step.fields.create :field_type => 'text', :name => 'Was there more properties bought during the marriage?
                                                            <br/><spain/>¿Compraron más propiedades durante el matrimonio?', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :looper_option => 'Yes', :dont_repeat => true




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_field.id, :render_if_field_value => 'Yes',#24
                                     :title => 'Property Division: Vehicles /<spain/>División de Propiedades: Vehículos',
                                     :description => 'Was there a car, motorcycle, rv, boat, trailer purchased during the marriage?
                                                      <br/><spain/>¿Compraron carro, moto, rv, barco, remolque durante el matrimonio?'

property_field = current_step.fields.create :field_type => 'radio', :name => 'No
                                                                              <option/>Yes /<spain/>Sí'






current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_field.id, :render_if_field_value => 'Yes',#25
                                     :title => 'Property Division: Vehicles /<spain/>División de Propiedades: Vehículos'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Car /<spain/>Carro', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Motorcycle /<spain/>Motocicleta', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'RV', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Boat /<spain/>Barco', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Trailer /<spain/>Remolque', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Other /<spain/>Otro', :toggle_id => toggle_id
current_step.fields.create :name => 'Write year, model and VIN # if you have it /<spain/>Escriba el año, modelo y VIN # si lo tiene', :toggle_id => toggle_id
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep it /<spain/>Esposa se quedara con ella
                                                             <option/>Sell it /<spain/>Vender
                                                             <option/>Husband will keep it /<spain/>Mi esposo se quedara con ella', :toggle_id => toggle_id


current_step.fields.create :field_type => 'text', :name => 'Was there another vehicle, motorcycle, rv, boat, trailer bought during the marriage?
                                                            <br/><spain/>¿Compraron otro vehículo, motocicleta, rv, barco, remolque durante el matrimonio?', :dont_repeat => true

current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :looper_option => 'Yes', :dont_repeat => true








current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_field.id, :render_if_field_value => 'Yes',#26
                                     :title => 'Property Division: Pension Benefit /<spain/>División de Beneficios de Pensión',
                                     :description => 'Is there a pension benefit, retirement fund, 401K, 403B, military pension, other retirement benefits obtain during the marriage?
                                                      <br/><spain/>¿Hay beneficio de Pensión, 401 k, 403B, pensión militar, otros beneficios de jubilación durante a matrimonio?'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :name => 'Name of the plan: /<spain/>Nombre del plan de beneficios:', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'I will keep /<spain/>Para Mi
                                                             <option/>I want a portion /<spain/>Quiero una porción
                                                             <option/>My spouse will keep it /<spain/>Para mi esposa(o)', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'Is there another retirement account? /<spain/>¿Hay otra cuenta de jubilación?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true







current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_field.id, :render_if_field_value => 'Yes',#27
                                     :title => 'Property Division: Bank and Investment Account
                                                <br/><spain/>División de Cuentas Bancarias e Inversiones',
                                     :description => 'Is there bank accounts, investment account or any other financial account obtain during the marriage?
                                                      <br/><spain/>¿Hay cuentas bancarias, de inversiones, u otro tipo de cuenta financiera obtenida  durante el matrimonio?'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id
current_step.fields.create :name => 'Name of the account /<spain/>Nombre de la cuenta', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :name => 'approximate amount in it /<spain/>la cantidad aproximada', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :name => 'last 4# (if possible) /<spain/>los ultimos 4# (si es posible):', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'I will keep /<spain/>Para Mi
                                                             <option/>I want a portion /<spain/>Quiero una porción
                                                             <option/>My spouse will keep it /<spain/>Para mi esposa(o)', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'Is there another account? /<spain/>¿Hay otra cuenta?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true







current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => property_division_field.id, :render_if_field_value => 'Yes',#28
                                     :title => 'Property Division: Other /<spain/>División de Bienes: Otro',
                                     :description => 'Is there anything else bought during the marriage that you want to keep?
                                                      <br/><spain/>¿Compro algo más durante el matrimonio que desea quedarse?'


other_property_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                                    <option/>No'

current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => other_property_field.id, :render_if_field_value => 'Yes',#29
                                     :title => 'Property Division: Other /<spain/>División de Bienes: Otro',
                                     :description => 'Check all that apply and you want to keep: /<spain/>Marque todas las cosas que le gustaría mantener:'

current_step.fields.create :field_type => 'checkbox', :name => 'household item /<spain/>cosas de la casa'
current_step.fields.create :field_type => 'checkbox', :name => 'Jewelry /<spain/>Joyas'
current_step.fields.create :field_type => 'checkbox', :name => 'Collections /<spain/>Collecciones'
current_step.fields.create :field_type => 'checkbox', :name => 'Furniture /<spain/>Muebles'
current_step.fields.create :field_type => 'checkbox', :name => 'Everything currently in my possession /<spain/>Todas las cosas en mi poder en este momento'






#
# END OF PROPERTY DIVISION
#




#
# DEBTS
#


current_step = template.steps.create :step_number => step_number += 1,#30
                                     :title => 'Debts /<spain/>Deudas',
                                     :description => 'Do you have community debts to divide?
                                                      <br/><spain/>¿Tienen deudas en común que dividir?'

current_step.fields.create :field_type => 'text', :name => 'Nevada is a community property state.  This means that the law presumes that all debts (credit cards, loans, mortgage, taxes, hospital bills, etc.) acquired or incurred during the marriage is community debts, and belongs equally to both parties, with the exception of separate debt.
                                                            <br/><spain/>Nevada es un estado de propiedad comunitaria.  Esto significa que la ley presupone que todas las deudas (tarjetas de crédito, préstamos, impuestos, cuenta de hospital, etc.) adquiridas o incurridas durante el matrimonio son responsabilidad de ambas partes y pertenecen igualmente a los dos, con la excepción de deudas individuales.'

debts_division_field = current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                                                    <option/>No
                                                                                    <option/>No, we already divided them /<spain/>No ya las dividimos'




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => debts_division_field.id, :render_if_field_value => 'Yes',#31
                                     :title => 'Debts Division: Home loan /<spain/>División de Deudas: Préstamo de Casa',
                                     :description => 'Is there a mortgage on the marital home?
                                                      <br/><spain/>¿Hay una hipoteca en la casa matrimonial?'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id
current_step.fields.create :name => 'Bank and amount owe /<spain/>Banco y cantidad que se debe:', :toggle_id => toggle_id, :toggle_option => 'Yes'
other_property_field = current_step.fields.create :field_type => 'radio', :name => 'Wife will keep /<spain/>Esposa va a pagar
                                                                                    <option/>Husband will keep /<spain/>Esposo va a pagar
                                                                                    <option/>Pay with sell of home /<spain/>Pagar con venta de casa', :toggle_id => toggle_id, :toggle_option => 'Yes'


current_step.fields.create :field_type => 'text', :name => 'Is there another debt associated with the marital home?
                                                            <br/><spain/>¿Existe otra deuda asociada con la casa matrimonial?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true

current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => debts_division_field.id, :render_if_field_value => 'Yes',#32
                                     :title => 'Debt Division: Credit Cards, hospital or medical bills
                                                <br/><spain/>División de Deuda: Tarjeta de Crédito, Cuenta de hospital o doctor:',
                                     :description => 'Are there any credit cards, hospital or medical bills to divide?
                                                      <br/><spain/>¿Tiene tarjetas de créditos, cuenta de hospital o doctores que dividir?'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :name => 'Card, amount, last 4# (if possible): (example Visa, $1000, #1234) /<spain/>Tarjeta, cantidad, últimos 4#: (ejemplo Visa, $ 1000, #1234)', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'radio', :name => 'Wife will keep /<spain/>Esposa va a pagar
                                                            <option/>Divide /<spain/>Dividir
                                                            <option/>Husband will keep /<spain/>Esposo va a pagar', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'Is there another credit card, hospital or doctor bill?
                                                            <br/><spain/>¿Hay otra tarjeta de crédito, cuenta de hospital o doctor que dividir?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true






current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => debts_division_field.id, :render_if_field_value => 'Yes',#33
                                     :title => 'Debt Division: Car Loan /<spain/>División de Deudas: Préstamo de Carro',
                                     :description => 'Is there any car, rv, boat, motorcycle loan to divide?
                                                      <br/><spain/>¿Tiene algún préstamo de carro, rv, barco, moto que dividir?'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :name => 'Bank and amount owe: (example Ford about $10,000) /<spain/>Banco y cantidad que se debe: (ejemplo Ford $10,000)', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep /<spain/>Esposa va a pagar
                                                             <option/>Divide /<spain/>Dividir
                                                             <option/>Husband will keep /<spain/>Esposo va a pagar', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'Is there another car, rv, boat, motorcycle loan to divide?
                                                            <br/><spain/>¿Tiene otro préstamo de carro, rv, barco, moto que dividir?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true





current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => debts_division_field.id, :render_if_field_value => 'Yes',#34
                                     :title => 'Debt Division: Student loans, IRS, payday loans, other /<spain/>División de Deuda: Préstamo estudiantil, IRS, otra deuda',
                                     :description => 'Is there any student loan, IRS, payday loans, other debt to divide?
                                                      <br/><spain/>¿Tiene algún préstamo estudiantil, IRS, otra deuda para dividir?'
toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :name => 'Type and amount owe: (example IRS about $10,000)
                                     <spain/>Tipo y deuda: (ejemplo IRS $10,000)', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'radio', :name => 'Wife will keep /<spain/>Esposa va a pagar
                                                             <option/>Divide /<spain/>Dividir
                                                             <option/>Husband will keep /<spain/>Esposo va a pagar', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'text', :name => 'Is there another student loan, IRS, payday loans, other debt to divide?
                                                            <br/><spain/>¿Tiene otro préstamo estudiantil, IRS, otra deuda para dividir?', :toggle_id => toggle_id, :toggle_option => 'Yes', :dont_repeat => true
current_step.fields.create :field_type => 'radio', :name => 'Yes /<spain/>Sí
                                                             <option/>No', :toggle_id => toggle_id, :toggle_option => 'Yes', :looper_option => 'Yes', :dont_repeat => true






current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => debts_division_field.id, :render_if_field_value => 'Yes',#35
                                     :title => 'Debt Division: Other /<spain/>División de Deuda: Otro',
                                     :description => 'Is there any other debt incurred during the marriage that you want to divide?
                                                      <br/><spain/>¿Hay otra deuda que fue adquirida durante el matrimonio que desea dividir?'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :name => 'Make a list of debts that need to be divided:
                                     <br/><spain/>Haga una lista de las deudas que se tienen que', :toggle_id => toggle_id, :toggle_option => 'Yes'



#
# END OF DEBTS
#




#
# ALIMONY
#


current_step = template.steps.create :step_number => step_number += 1,#36
                                     :title => 'Spousal support or Alimony /<spain/>Manutención de Esposa(o)',
                                     :description => 'Will there be spousal support/alimony?
                                                      <br/><spain/>¿Va haber manutención de esposa(o)?'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'No
                                                             <option/>Yes /<spain/>Sí', :toggle_id => toggle_id

current_step.fields.create :field_type => 'radio', :name => 'Wife WILL PAY spousal support $ /<spain/>Esposo PAGARA manutención en la cantidad de $(ponga la cantidad mensual) por mes.
                                                             <option/>Husband WILL PAY spousal support $ /<spain/>Esposa PAGARA manutención en la cantidad de $(ponga la cantidad mensual) por mes.', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'amount', :name => 'Enter monthly amount', :toggle_id => toggle_id, :toggle_option => 'Yes'
current_step.fields.create :field_type => 'amount', :name => 'For how long ? (enter number) /<spain/>¿Por cuánto tiempo? (ponga en número)', :toggle_id => toggle_id, :toggle_option => 'Yes'

current_step.fields.create :field_type => 'radio', :name => 'Months /<spain/>Meses
                                                             <option/>Year(s) (example 1 year) /<spain/>Año(s)  (ejemplo 1 año)', :toggle_id => toggle_id, :toggle_option => 'Yes'


current_step = template.steps.create :step_number => step_number += 1,#37
                                     :title => 'Wife’s Name /<spain/>Cambio de Apellido'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'radio', :name => 'Wife never change her name /<spain/>La esposa nunca se cambió el apellido
                                                             <option/>Wife will keep married name /<spain/>La esposa se va a quedar con el apellido de casada
                                                             <option/>Wife will return to her maiden name /<spain/>La esposa volverá a su apellido de soltera que es', :toggle_id => toggle_id

current_step.fields.create :toggle_id => toggle_id, :name => 'Wife\'s maiden name', :toggle_option => 'Wife will return'



current_step = template.steps.create :step_number => step_number += 1,#38
                                     :title => 'Reason for divorce  /<spain/>Razón por el divorcio',
                                     :description => 'Nevada is a "no fault" divorce state.  This means the person seeking the divorce does not have to prove in court that she or he is entitled to a divorce.
                                                      <br/><spain/>Nevada es un estado de divorcio "sin culpa".  Esto significa que la persona que busca el divorcio no tiene que probar en la corte que él o ella tiene el derecho a divorciarse.'

current_step.fields.create :field_type => 'radio', :name => 'I no longer want to be married /<spain/>Ya no quiero seguir casado porque no nos entendemos
                                                             <option/>I no longer want to be married and have lived separated and apart for over 1 year /<spain/>Ya no quiero seguir casada y hemos vivido separados desde hace más de 1 año'



current_step = template.steps.create :step_number => step_number += 1,#39
                                     :title => 'Other cases in Family court /<spain/>Otros casos en la corte de Familia',
                                     :description => 'Do you or other party in this case (including any minor child) have any other current case(s) or past case(s) in the Family Court or Juvenile Court in (insert county) County?
                                                      <br/><spain/>¿Ha tenido o tiene usted u la otra persona en este caso (incluyendo cualquier de sus menores) otros casos en la corte de familia en el Condado de (insert county)?'

other_cases_field = current_step.fields.create :field_type => 'radio', :name => 'No
                                                                                 <option/>Yes /<spain/>Sí'




current_step = template.steps.create :step_number => step_number += 1, :render_if_field_id => other_cases_field.id, :render_if_field_value => 'Yes',#40
                                     :title => 'Other cases in Family court /<spain/>Otros casos en la corte de Familia',
                                     :description => '** If you don\'t remember write as much as you remember.
                                                      <br/><spain/>** Si no recuerdas toda la información escriba lo que recuerde.'

toggle_id = 0
toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Divorce /<spain/>Divorcio', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id


current_step.fields.create :field_type => 'checkbox', :name => 'Temporary Protective Order (TPO) /<spain/>Orden de Protección'

toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Custody or Child Support /<spain/>Custodia  o Manutención de menor', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Paternity /<spain/>Paternidad', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Juvenile Court or abuse and neglect /<spain/>Corte juvenil o abuso y negligencia', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Guardianship /<spain/>Tutela', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id


toggle_id += 1
current_step.fields.create :field_type => 'checkbox', :name => 'Termination of Parental Rights /<spain/>Terminación de la patria potestad', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Person involved: /<spain/>Persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :name => 'Other person involved: /<spain/>La otra persona involucrada:', :toggle_id => toggle_id
current_step.fields.create :name => 'Last name /<spain/>Apellido', :toggle_id => toggle_id
current_step.fields.create :name => 'First name /<spain/>Nombre', :toggle_id => toggle_id
current_step.fields.create :name => 'Middle name /<spain/>Segundo nombre', :toggle_id => toggle_id
current_step.fields.create :field_type => 'amount', :name => 'Case # /<spain/># de caso:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'date', :name => 'Date of last Order: /<spain/>Día de la ultima orden:', :toggle_id => toggle_id
current_step.fields.create :field_type => 'text', :toggle_id => toggle_id



current_step.fields.create :field_type => 'link:sep:https://www.clarkcountycourts.us/Anonymous/default.aspx', :name => 'Don’t remember the date? Click here
                                                                                                                        <br/><spain/>¿No recuerda la fecha? Haz clic'


#
# END OF ALIMONY
#

















