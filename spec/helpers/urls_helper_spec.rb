require "spec_helper"

describe '#destiny_button' do
  context 'when creating a button for the state "manual"' do
    subject { helper.destiny_button(:manual) }

    it { should include('name="destiny"') }
    it { should include('class="manual"') }
    it { should include('type="submit"') }
    it { should include('value="manual"') }
  end
end