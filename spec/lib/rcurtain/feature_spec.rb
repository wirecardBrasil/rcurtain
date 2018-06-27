require '../../spec_helper'

describe RCurtain do
  describe 'Feature' do
    subject(:feature) { RCurtain.feature }
    let(:redis) { Redis.new }
    let(:feature_name) { 'feature' }

    describe 'users' do
      let(:users) { ['MPA-000000000000'] }
      let(:feature_users) { subject.format_name(feature_name, 'users') }

      describe '#add' do
        before do
          subject.add(feature_name, users)
        end

        context 'when adding user' do
          it 'is enabled for user' do
            expect(redis.smembers(feature_users)).to eq(users)
          end
        end
      end

      describe '#remove' do
        before do
          subject.remove(feature_name, users)
        end

        context 'when removing user' do
          it 'is disabled for user' do
            expect(redis.smembers(feature_users).size).to eq(0)
          end
        end
      end

      describe '#list' do
        before do
          subject.add(feature_name, users)
        end

        context 'when listing users' do
          it 'has correct user list' do
            expect(subject.list(feature_name)).to eq(users)
          end
        end
      end

      describe '#user?' do
        context 'when checking if user is enabled' do
          it 'is enabled for user' do
            expect(subject.user?(feature_name, users[0])).to be true
          end
        end
      end
    end

    describe 'percentage' do
      let(:feature_percentage) { subject.format_name(feature_name, 'percentage') }

      describe '#update' do
        before do
          subject.update(feature_name, 100)
        end

        context 'when updating percentage' do
          it 'has correct percentage' do
            expect(redis.get(feature_percentage).to_i).to eq(100)
          end
        end
      end

      describe '#number' do
        context 'when retrieving percentage' do
          it 'has correct percentage' do
            expect(subject.number(feature_name).to_i).to eq(100)
          end
        end
      end
    end

    describe 'description' do
      let(:feature_desc) { subject.format_name(feature_name, 'description') }
      let(:description) { 'Description' }

      describe '#describe' do
        before do
          subject.describe(feature_name, description)
        end

        context 'when setting description' do
          it 'has correct description' do
            expect(redis.get(feature_desc)).to eq(description)
          end
        end
      end

      describe '#description' do
        context 'when retrieving feature description' do
          it 'has correct description' do
            expect(subject.description(feature_name)).to eq(description)
          end
        end
      end
    end
  end
end
