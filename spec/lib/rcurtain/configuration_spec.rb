require 'spec_helper'

describe RCurtain do
  describe 'Configuration' do
    subject(:configuration) { RCurtain.configuration }

    describe '#configure' do
      context 'when configuring url' do
        before do
          RCurtain.configure do |config|
            config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
          end
        end

        it 'has correct url' do
          expect(subject.url).to eq('redis://:p4ssw0rd@10.0.1.1:6380/15')
        end
      end

      context 'when configuring default response' do
        before do
          RCurtain.configure do |config|
            config.default_response = true
          end
        end

        it 'has correct default response' do
          expect(subject.default_response).to be true
        end
      end

      context 'when configuring default percentage' do
        before do
          RCurtain.configure do |config|
            config.default_percentage = 100
          end
        end

        it 'has correct default response' do
          expect(subject.default_percentage).to eq(100)
        end
      end

      context 'when configuring default description' do
        before do
          RCurtain.configure do |config|
            config.default_description = 'Description'
          end
        end

        it 'has correct default description' do
          expect(subject.default_description).to eq('Description')
        end
      end

      context 'when configuring feature name format' do
        before do
          RCurtain.configure do |config|
            config.feature_name_format = '%name%'
          end
        end

        it 'has correct feature name format' do
          expect(subject.feature_name_format).to eq('%name%')
        end
      end
    end
  end
end
