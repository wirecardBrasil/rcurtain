require 'spec_helper'

describe RCurtain do
  describe 'Curtain' do
    subject(:curtain) { RCurtain.instance }
    let(:redis) { Redis.new(url: RCurtain.configuration.url) }
    let(:feature) { RCurtain.feature }
    let(:feature_name) { 'feature' }
    let(:users) { ['MPA-000000000000'] }

    describe '#open?' do
      before do
        feature.add_user(feature_name, users)
      end

      context 'when checking if user is enabled' do
        it 'should be enabled for user' do
          expect(subject.open?(feature_name, users)).to be true
        end
      end
    end
  end
end
