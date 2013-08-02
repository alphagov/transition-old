require "spec_helper"

##
# The imported_files were not being linked to the FailedUrls.
# This was as a result of porting this into the Raw:: namespace
# and forgetting to set a :foreign_key manually. Fine, I thought.
# Quick spec for that.  However, I've discovered that
# +Transition::Import::Raw::Urls.import_file+ is incorrectly throwing away URLs
# in this spec. This is at odds with the passing specs in optic14n.
#
# I'm just not seeing what's causing it though. Help?
#
describe Transition::Import::Raw::Urls do
  describe '.import_file', expensive_setup: true do
    before(:all) do
      Transition::Import::Raw::Urls.import_file(fixture_file('voa_abridged.txt'))
    end

    specify { ::Raw::Url.all.should have(2).urls }
    specify { ::Raw::Url.first.url.should == 'http://www.voa.gov.uk' }
    specify { ::Raw::Url.last.url.should == 'http://www.voa.gov.uk' }
    specify { ::Raw::ImportedFile.first.urls_seen.should == 3 }

    describe 'the failed URL' do
      subject { Raw::FailedUrl.first }

      specify { Raw::FailedUrl.all.should have(1).failed_url }

      its(:error)         { should include 'invalid UTF-8' }
      its(:imported_file) { should be_a Raw::ImportedFile }
    end
  end
end
