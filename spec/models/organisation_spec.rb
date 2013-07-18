require 'spec_helper'

describe Organisation do
  context :relationships do
    it { should have_many(:sites) }
    it { should have_many(:hosts).through(:sites) }
    it { should have_many(:mappings).through(:sites) }
    it { should have_many(:totals).through(:hosts) }
    it { should have_many(:hits).through(:sites) }
    it { should have_many(:urls).through(:sites) }
    it { should have_many(:url_groups).dependent(:restrict) }
    it { should have_many(:user_needs).dependent(:restrict) }
  end

  context :status_summary do
    before :each do
      @organisation = create :organisation
      @site = create :site, organisation: @organisation
      create(:url, site: @site, workflow_state: "new")
      create(:url, site: @site, workflow_state: "unfinished")
      create(:url, site: @site, workflow_state: "unfinished")
      create(:url, site: @site, workflow_state: "redirected")
      create(:url, site: @site, workflow_state: "redirected")
      create(:url, site: @site, workflow_state: "redirected")
    end

    it "should summarise the workflow state of urls" do
      @organisation.summarise_url_state.should == {
        "new" => 1,
        "unfinished" => 2,
        "redirected" => 3
      }
    end
  end
end
