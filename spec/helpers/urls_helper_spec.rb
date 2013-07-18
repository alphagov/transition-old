require 'spec_helper'

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