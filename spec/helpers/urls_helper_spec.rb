require 'spec_helper'

describe '#destiny_button' do
  context 'the URL is :new and we''re creating a button for the state "manual"' do
    let(:url) { FactoryGirl.build(:url) }

    subject { helper.destiny_button(url, :manual) }

    it { should include('name="destiny"') }
    it { should include('class="manual"') }
    it { should include('type="submit"') }
    it { should include('value="manual"') }
  end

  context 'the URL has a state of :archive and we''re creating a button for the state "archive"' do
    let(:url) { FactoryGirl.create(:url, workflow_state: :archive) }

    subject { helper.destiny_button(url, :archive) }

    it { should include('name="destiny"') }
    it { should include('class="selected archive"') }
    it { should include('type="submit"') }
    it { should include('value="archive"') }
  end
end