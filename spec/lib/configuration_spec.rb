require 'spec_helper'

describe Rcurtain do
  subject(:rcurtain) { Rcurtain.configuration }

  describe '#configure' do
    context 'when configuring url for redis' do
      before do
        Rcurtain.configure do |config|
          config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
        end
      end

      it 'has correct url' do
        expect(subject.url).to eq('redis://:p4ssw0rd@10.0.1.1:6380/15')
      end
    end

    context 'when configuring default response' do
      before do
        Rcurtain.configure do |config|
          config.default_response = true
        end
      end

      it 'has correct default response' do
        expect(subject.default_response).to be true
      end
    end

    context 'when configuring feature name format' do
      before do
        Rcurtain.configure do |config|
          config.feature_name_format = 'feature-%name%-'
        end
      end

      it 'has correct feature name format' do
        expect(subject.feature_name_format).to eq('feature-%name%-')
      end
    end
  end
end
