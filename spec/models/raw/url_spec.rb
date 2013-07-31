require "spec_helper"

module Raw
  describe Url do
    describe '.parse_extension' do
      specify { Url.parse_extension('/somewhere/something.pdf').should eql('pdf') }
      specify { Url.parse_extension('/somewhere/something.gif').should eql('gif') }
      specify { Url.parse_extension('/').should eql(nil) }
      specify { Url.parse_extension('pg/6c/_pg/6c/.reqid/0').should eql(nil) }
      specify { Url.parse_extension('/themes/basic.new.css').should eql('css') }
      specify { Url.parse_extension('/inshtm/section3/000001.htm++++').should eql('htm') }
      specify { Url.parse_extension('/inshtm/section3/000001.htm%20%20%20%20').should eql('htm') }
    end
  end
end