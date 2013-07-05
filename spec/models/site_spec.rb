require 'spec_helper'

describe Site do
  context :relationships do
    it { should belong_to(:organisation) }
    it { should have_many(:hosts) }
    it { should have_many(:hits).through(:hosts) }
    it { should have_many(:totals).through(:hosts) }
    it { should have_many(:mappings) }
    it { should have_many(:urls).dependent(:restrict) }
  end
end