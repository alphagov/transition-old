require 'spec_helper'

describe UrlsHelper do
  describe '#classy_link' do
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

  describe 'grouped_options_for_content_type_select', expensive_setup: true do
    let(:url)          { create :url_with_content_type }
    let(:content_type) { create :content_type }

    # Yes, this helper method talks to the database. No, don't ask.
    before do
      # Make sure these exist
      [content_type, url]
    end

    shared_examples 'it groups' do
      it 'groups the Publication in an <optgroup>' do
        rendered.should include('optgroup label="Publication"')
      end
    end

    shared_examples 'it counts' do
      it 'has one item with a count' do
        rendered.should include('data-url-count="1"')
        rendered.should include("#{url.content_type.subtype} (1)")
      end

      it 'has one item without' do
        rendered.should include('data-url-count="0"')
        rendered.should include(content_type.subtype)
      end
    end

    shared_examples 'it does not count' do
      it 'does not have data-url-count=' do
        rendered.should_not include('data-url-count=')
      end

      it 'does not have bracketed display counts' do
        rendered.should_not include(' (1)')
      end
    end

    context ':show_counts is true' do
      context 'a url is given' do
        subject(:rendered) { helper.grouped_options_for_content_type_select(url, show_counts: true) }

        it_behaves_like 'it groups'
        it_behaves_like 'it counts'
      end

      context 'a content type id is given' do
        subject(:rendered) { helper.grouped_options_for_content_type_select(url.content_type_id, show_counts: true) }

        it_behaves_like 'it groups'
        it_behaves_like 'it counts'
      end
    end

    context ':show_counts is false/not given' do
      context 'a url is given' do
        subject(:rendered) { helper.grouped_options_for_content_type_select(url) }

        it_behaves_like 'it groups'
        it { should_not include(' (1)') }
      end

      context 'a content type id is given' do
        subject(:rendered) { helper.grouped_options_for_content_type_select(url.content_type_id) }

        it_behaves_like 'it groups'
        it { should_not include(' (1)') }
      end
    end
  end
end