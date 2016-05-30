require 'spec_helper'

describe Rcurtain do

  describe "#configure" do

    context "configure url for redis" do
      before do
        Rcurtain.configure do |config|
          config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
        end
      end

      subject(:rcurtain) { Rcurtain.configuration }

      it {expect(subject.url).to eq('redis://:p4ssw0rd@10.0.1.1:6380/15')}

    end

    context "configure default response" do
      before do
        Rcurtain.configure do |config|
          config.default_response = true
        end
      end

      subject(:rcurtain) { Rcurtain.configuration }

      it {expect(subject.default_response).to eq true}
    end

  end

end
