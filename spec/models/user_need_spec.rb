require 'spec_helper'

describe UserNeed do
  describe :relationships do
    it { should belong_to(:organisation) }
  end

  describe :validations do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end