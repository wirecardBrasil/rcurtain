require 'spec_helper'
require 'fakeredis/rspec'

describe Rcurtain do
  subject(:rcurtain) { Rcurtain.feature }
  let(:curtain) { Rcurtain.instance }
  let(:users) { ['MPA-000000000000', 'MPA-111111111111'] }

  describe '#add' do
    before do
      subject.add('feature', users)
    end

    context 'when adding single user' do
      let(:users) { ['MPA-00000000000'] }

      it 'should be enabled to added user' do
        expect(curtain.opened?('feature', users)).to be true
      end
    end

    context 'when adding multiple users' do
      it 'should be enabled to added users' do
        expect(curtain.opened?('feature', users)).to be true
      end
    end
  end

  describe '#remove' do
    before do
      subject.add('feature', users)
      subject.remove('feature', users)
    end

    context 'when removing single user' do
      let(:users) { ['MPA-00000000000'] }

      it 'should be disabled to removed user' do
        expect(curtain.opened?('feature', users)).to be false
      end
    end

    context 'when removing multiple users' do
      it 'should be disabled to removed users' do
        expect(curtain.opened?('feature', users)).to be false
      end
    end
  end

  describe '#delete_users' do
    before do
      subject.add('feature', users)
      subject.delete_users('feature')
    end

    context 'when deleting all users from feature' do
      it 'should delete all users' do
        expect(subject.user?('feature', 'MPA-000000000000')).to be false
      end
    end
  end

  describe '#update' do
    before do
      subject.update('feature', percentage)
    end

    context 'when updating percentage to 100 percent' do
      let(:percentage) { 100 }

      it 'should be enabled to all users' do
        expect(curtain.opened?('feature')).to be true
      end
    end

    context 'when updating percentage to 0 percent' do
      let(:percentage) { 0 }

      it 'should be disabled to all users' do
        expect(curtain.opened?('feature')).to be false
      end
    end
  end

  describe '#user?' do
    before do
      subject.add('feature', users)
    end

    context 'when user is enabled' do
      it 'should be enabled for user' do
        expect(subject.user?('feature', users[0])).to be true
      end
    end
  end

  describe '#number' do
    context 'when percentage is any value' do
      let(:rand) { Random.new.rand(1..100) }

      before do
        subject.update('feature', rand)
      end

      it 'should return correct percentage value' do
        expect(subject.number('feature')).to eq(rand)
      end
    end
  end
end
