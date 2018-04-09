require 'spec_helper'
describe Rcurtain do
  before do
    Rcurtain.configure do |config|
      config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
    end
  end
  subject(:rcurtain) { Rcurtain.instance }

  describe '#opened?' do

    context 'when connection is successful' do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(percentage)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(users)
      end

      let(:users) { ['MPA-000000000000', 'MPA-111111111111'] }

      context 'when percentage is fully opened' do
        let(:percentage) { 100 }
        let(:users) { nil }

        it 'should be true' do
          expect(subject.opened?('feature')).to be true
        end
      end

      context 'when percentage is fully closed' do
        let(:percentage) { 0 }

        context 'and all users are enabled' do
          it 'should be true' do
            expect(subject.opened?('feature', users)).to be true
          end
        end

        context 'and only one user is enabled' do
          let(:users) { ['MPA-000000000000'] }

          it 'should be false' do
            users = ['MPA-000000000000', 'MPA-111111111111']
            expect(subject.opened?('feature', users)).to be false
          end
        end

        context 'and no user is enabled' do
          let(:users) { nil }

          it 'should be false' do
            expect(subject.opened?('feature')).to be false
          end
        end
      end
    end

    context 'when connection fails' do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_raise(Redis::CannotConnectError)
        allow_any_instance_of(Redis).to receive(:smembers).and_raise(Redis::CannotConnectError)
      end

      it 'should be false' do
        expect(subject.opened?('feature')).to be false
      end
    end
  end
end
