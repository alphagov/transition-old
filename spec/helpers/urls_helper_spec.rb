require "spec_helper"

describe '#destiny_buttons' do
  it 'creates a button with the right class, name, and title' do
    markup = helper.destiny_button(:manual)
    markup.should == '<button class="manual" name="destiny" type="submit" value="manual">Manual</button>'
  end
end