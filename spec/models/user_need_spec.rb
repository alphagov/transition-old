require 'spec_helper'

describe UserNeed do
  describe :relationships do
    it { should belong_to(:organisation) }
  end

  describe :validations do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  it 'generates needotron-compatible ids' do
    need = create :user_need
    need.needotron_id.should == need.id + UserNeed::ARBITRARY_NEEDOTRON_ID_GAP
  end
end