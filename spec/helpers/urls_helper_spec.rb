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
    let(:url) { create(:url, workflow_state: :archive) }

    subject { helper.destiny_button(url, :archive) }

    it { should include('name="destiny"') }
    it { should include('class="selected archive"') }
    it { should include('type="submit"') }
    it { should include('value="archive"') }
  end
end

describe '#url_classy_link' do
  context 'the URL is :new' do
    let(:url)         { build(:url, id: 1) }
    let(:current_url) { build(:url, url: 'http://elsewhere', id: 2) }

    context "it's the current URL" do
      subject { helper.classy_link(url, url) }

      it { should eql(url.url) }
    end

    context "it's visible in the list, but not current" do
      subject { helper.classy_link(url, current_url) }

      it { should include('<a') }
      it { should include('class="new"') }
    end
  end
end