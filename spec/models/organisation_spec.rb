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
end
