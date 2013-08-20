require 'spec_helper'

describe Transition::Google::APIClient do
  before :all do
    @client = Transition::Google::APIClient.analytics_client!
  end

  describe '.analytics_client!', external_api: true do
    it 'is a Google::APIClient' do
      @client.should be_a(Google::APIClient)
    end

    it 'has a token that is a non-zero length string' do
      @client.authorization.access_token.tap do |token|
        token.should be_a String
        token.length.should > 0
      end
    end
  end
end