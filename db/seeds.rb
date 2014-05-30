template = Template.create :name => 'Test one', :description => 'Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui.'

template.fields.create :name => 'First question', :step_number => 1, :order_number => 1
template.fields.create :name => 'Second question', :step_number => 2, :order_number => 1
template.fields.create :name => 'Third question', :step_number => 2, :order_number => 2
template.fields.create :name => 'Fourth question', :step_number => 3, :order_number => 1
template.fields.create :name => 'Fifth question', :step_number => 3, :order_number => 2
