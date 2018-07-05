require 'spec_helper'

describe RCurtain do
  describe 'Curtain' do
    subject(:curtain) { RCurtain.instance }
    let(:redis) { Redis.new(url: RCurtain.configuration.url) }
    let(:feature) { RCurtain.feature }
    let(:feature_name) { 'curtain_feature' }
    let(:users) { ['MPA-000000000000'] }

    describe '#open?' do
      context 'when checking if user is enabled by name' do
        before do
          feature.add_users(feature_name, users)
        end

        it 'should be enabled for user' do
          expect(subject.open?(feature_name, users)).to be true
        end
      end

      context 'when checking if user is enabled by percentage' do
        let(:users) { ['MPA-111111111111'] }

        before do
          feature.set_percentage(feature_name, 100)
        end

        it 'should be enabled for user' do
          expect(subject.open?(feature_name, users)).to be true
        end

        after do
          feature.set_percentage(feature_name, 0)
        end
      end
    end

    describe '#users_allowed?' do
      let(:users) { ['MPA-000000000000', 'MPA-111111111111'] }

      context 'when all users are allowed' do
        before do
          feature.add_users(feature_name, users)
        end

        it 'is enabled for all users' do
          expect(subject.send('users_allowed?', feature_name, users)).to be true
        end

        after do
          feature.remove_users(feature_name, users)
        end
      end

      context 'when only one user is allowed' do
        let(:allowed_users) { ['MPA-000000000000'] }

        before do
          feature.add_users(feature_name, allowed_users)
        end

        it 'should be disabled for users' do
          expect(subject.send('users_allowed?', feature_name, users))
            .to be false
        end

        after do
          feature.remove_users(feature_name, allowed_users)
        end
      end

      context 'when no user is allowed' do
        it 'should be disabled for users' do
          expect(subject.send('users_allowed?', feature_name, users))
            .to be false
        end
      end

      context 'when redis connection fails' do
        before do
          fail_redis(:sismemer)
        end

        it 'returns default value' do
          expect(subject.send('users_allowed?', feature_name, users))
            .to eq(RCurtain.configuration.default_response)
        end
      end
    end

    describe '#percentage_allowed?' do

    end

    describe '#allowed_percentage' do
      context 'when redis connection fails' do
        before do
          fail_redis(:get)
        end

        it 'returns default value' do
          expect(subject.send('allowed_percentage', feature_name))
            .to eq(RCurtain.configuration.default_percentage)
        end
      end
    end
  end
end
