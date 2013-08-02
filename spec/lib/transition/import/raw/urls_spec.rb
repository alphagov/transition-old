require "spec_helper"

describe Transition::Import::Raw::Urls do
  describe '.import_file', expensive_setup: true do
    before(:all) do
      # import_file just calls Optic14n::CanonicalizedUrls.from_urls(File.read(filename).each_line, allow_query: :all)
      # The important thing is allow_query: :all - querystrings are being stripped
      Transition::Import::Raw::Urls.import_file(fixture_file('voa_abridged.txt'))
    end

    specify { ::Raw::ImportedFile.first.urls_seen.should == 3 }
    specify { ::Raw::Url.all.should have(2).urls }
    specify { ::Raw::Url.first.url.should == 'http://www.voa.gov.uk' }
    specify { ::Raw::Url.last.url.should == 'http://www.voa.gov.uk/stuff' }

    describe 'the failed URL' do
      subject { Raw::FailedUrl.first }

      specify { Raw::FailedUrl.all.should have(1).failed_url }

      its(:failure) { should include 'invalid byte sequence in UTF-8' }
      its(:imported_file) { should be_a Raw::ImportedFile }
    end
  end
end
