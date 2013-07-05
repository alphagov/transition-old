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
end
