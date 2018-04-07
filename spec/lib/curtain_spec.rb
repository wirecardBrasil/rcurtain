require 'spec_helper'
describe Rcurtain do
  before do
    Rcurtain.configure do |config|
      config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
    end
  end
  subject(:rcurtain) { Rcurtain.instance }

  describe '#opened?' do
    let(:user) { ['MPA-00000000000'] }
    let(:users) { ['MPA-000000000000', 'MPA-111111111111'] }

    context 'when percentage is fully opened' do
      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(100)
        allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
      end

      it 'should be true' do
        expect(subject.opened?('feature')).to be true
      end
    end

    context 'when percentage is fully closed' do
      context 'and all users are enabled' do
        before do
          allow_any_instance_of(Redis).to receive(:get).and_return(0)
          allow_any_instance_of(Redis).to receive(:smembers).and_return(user)
        end

        it 'should be true' do
          expect(subject.opened?('feature', user)).to be true
        end
      end

      context 'and only one user is enabled' do
        before do
          allow_any_instance_of(Redis).to receive(:get).and_return(0)
          allow_any_instance_of(Redis).to receive(:smembers).and_return(user)
        end

        it 'should be false' do
          expect(subject.opened?('feature', users)).to be false
        end
      end

      context 'and no user is enabled' do
        before do
          allow_any_instance_of(Redis).to receive(:get).and_return(0)
          allow_any_instance_of(Redis).to receive(:smembers).and_return(nil)
        end

        it 'should be false' do
          expect(subject.opened?('feature')).to be false
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
