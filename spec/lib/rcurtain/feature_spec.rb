require 'spec_helper'

describe RCurtain do
  describe 'Feature' do
    subject(:feature) { RCurtain.feature }
    let(:feature_name) { 'feature' }

    describe 'users' do
      let(:users) { ['MPA-000000000000'] }
      let(:feature_users) { subject.send('format_name', feature_name, 'users') }

      describe '#add_users' do
        before do
          subject.add_users(feature_name, users)
        end

        context 'when adding user' do
          it 'is enabled for user' do
            expect(subject.list_users(feature_name)).to eq(users)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:sadd)
          end

          it 'returns default value' do
            expect(subject.add_users(feature_name, users))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end

      describe '#remove_users' do
        before do
          subject.remove_users(feature_name, users)
        end

        context 'when removing user' do
          it 'is disabled for user' do
            expect(subject.list_users(feature_name).size).to eq(0)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:srem)
          end

          it 'returns default value' do
            expect(subject.remove_users(feature_name, users))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end

      describe '#list_users' do
        before do
          subject.add_users(feature_name, users)
        end

        context 'when listing users' do
          it 'has correct user list' do
            expect(subject.list_users(feature_name)).to eq(users)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:smembers)
          end

          it 'returns default value' do
            expect(subject.list_users(feature_name))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end

      describe '#user_enabled?' do
        context 'when checking if user is enabled' do
          it 'is enabled for user' do
            expect(subject.user_enabled?(feature_name, users[0])).to be true
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:sismember)
          end

          it 'returns default value' do
            expect(subject.user_enabled?(feature_name, users[0]))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end
    end

    describe 'percentage' do
      let(:feature_percentage) do
        subject.send('format_name', feature_name, 'percentage')
      end

      describe '#set_percentage' do
        before do
          subject.set_percentage(feature_name, 100)
        end

        context 'when updating percentage' do
          it 'has correct percentage' do
            expect(subject.percentage(feature_name)).to eq(100)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:set)
          end

          it 'returns default value' do
            expect(subject.set_percentage(feature_name, 100))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end

      describe '#percentage' do
        context 'when retrieving percentage' do
          it 'has correct percentage' do
            expect(subject.percentage(feature_name).to_i).to eq(100)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:get)
          end

          it 'returns default value' do
            expect(subject.percentage(feature_name))
              .to eq(RCurtain.configuration.default_percentage)
          end
        end
      end
    end

    describe 'description' do
      let(:feature_desc) do
        subject.send('format_name', feature_name, 'description')
      end
      let(:description) { 'Description' }

      describe '#describe' do
        before do
          subject.describe(feature_name, description)
        end

        context 'when setting description' do
          it 'has correct description' do
            expect(feature.description(feature_name)).to eq(description)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:set)
          end

          it 'returns default value' do
            expect(subject.describe(feature_name, description))
              .to eq(RCurtain.configuration.default_response)
          end
        end
      end

      describe '#description' do
        context 'when retrieving feature description' do
          it 'has correct description' do
            expect(subject.description(feature_name)).to eq(description)
          end
        end

        context 'when redis connection fails' do
          before do
            fail_redis(:get)
          end

          it 'returns default value' do
            expect(subject.description(feature_name))
              .to eq(RCurtain.configuration.default_description)
          end
        end
      end
    end
  end
end
