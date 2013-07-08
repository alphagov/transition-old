require 'spec_helper'

describe Organisation do
  context :relationships do
    it { should have_many(:sites) }
    it { should have_many(:hosts).through(:sites) }
    it { should have_many(:mappings).through(:sites) }
    it { should have_many(:totals).through(:hosts) }
    it { should have_many(:hits).through(:sites) }
    it { should have_many(:urls).through(:sites) }
  end

  context :status_summary do
    before :each do
      @organisation = create :organisation
      @site = create :site, organisation: @organisation
      create(:url, site: @site, workflow_state: "new")
      create(:url, site: @site, workflow_state: "manual")
      create(:url, site: @site, workflow_state: "manual")
      create(:url, site: @site, workflow_state: "redirected")
      create(:url, site: @site, workflow_state: "redirected")
      create(:url, site: @site, workflow_state: "redirected")
      create(:url, site: @site, workflow_state: "archived")
      create(:url, site: @site, workflow_state: "archived")
      create(:url, site: @site, workflow_state: "archived")
      create(:url, site: @site, workflow_state: "archived")
    end

    it "should summarise the workflow state of urls" do
      @organisation.summarise_url_state.should == {
        "new" => 1,
        "manual" => 2,
        "redirected" => 3,
        "archived" => 4
      }
    end
  end

  context :adjacent_urls do
    before :each do
      @organisation = create :organisation
      @site = create :site, organisation: @organisation
      10.times {|i| instance_variable_set("@url#{i + 1}", create(:url, site: @site)) }
    end

    it "should return 3 urls with @url1 in the first position" do
      urls = @organisation.adjacent_urls(@url1, 3)
      urls.should == [@url1, @url2, @url3]
    end
    it "should return 3 urls with @url2 in the second position" do
      urls = @organisation.adjacent_urls(@url2, 3)
      urls.should == [@url1, @url2, @url3]
    end
    it "should return 3 urls with @url3 in the second position" do
      urls = @organisation.adjacent_urls(@url3, 3)
      urls.should == [@url2, @url3, @url4]
    end
    it "should return 4 urls with @url3 in the third position" do
      urls = @organisation.adjacent_urls(@url3, 4)
      urls.should == [@url1, @url2, @url3, @url4]
    end
    it "should return 5 urls with @url9 in the fourth position" do
      urls = @organisation.adjacent_urls(@url9, 5)
      urls.should == [@url6, @url7, @url8, @url9, @url10]
    end
    it "should return 5 urls with @url10 in the fifth position" do
      urls = @organisation.adjacent_urls(@url10, 5)
      urls.should == [@url6, @url7, @url8, @url9, @url10]
    end
  end
end
