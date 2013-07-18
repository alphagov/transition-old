require 'spec_helper'

describe ScrapeResult do
  describe :relationships do
    it { should belong_to(:scrapable) }
  end

  describe :validations do
    it { should validate_presence_of(:scrapable) }
  end
end
