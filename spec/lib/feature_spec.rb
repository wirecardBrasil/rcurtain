require 'spec_helper'
require 'fakeredis/rspec'

describe Rcurtain do
  subject(:rcurtain) { Rcurtain.feature }
  let(:curtain) { Rcurtain.instance }
  let(:user) { ['MPA-00000000000'] }
  let(:users) { ['MPA-000000000000', 'MPA-111111111111'] }

  describe '#add_user' do
    context 'when adding single user' do
      before do
        subject.add_users('feature', user)
      end

      it 'should be enabled to added user' do
        expect(curtain.opened?('feature', user)).to be true
      end
    end

    context 'when adding multiple users' do
      before do
        subject.add_users('feature', users)
      end

      it 'should be enabled to added users' do
        expect(curtain.opened?('feature', users)).to be true
      end
    end
  end

  describe '#remove_users' do
    before do
      subject.add_users('feature', users)
    end

    context 'when removing single user' do
      before do
        subject.remove_users('feature', user)
      end

      it 'should be disabled to removed user' do
        expect(curtain.opened?('feature', user)).to be false
      end
    end

    context 'when removing multiple users' do
      before do
        subject.remove_users('feature', users)
      end

      it 'should be disabled to removed users' do
        expect(curtain.opened?('feature', users)).to be false
      end
    end
  end

  describe '#update_percentage' do
    context 'when updating percentage to 100 percent' do
      before do
        subject.update_percentage('feature', 100)
      end

      it 'should be enabled to all users' do
        expect(curtain.opened?('feature')).to be true
      end
    end

    context 'when updating percentage to 0 percent' do
      before do
        subject.update_percentage('feature', 0)
      end

      it 'should be disabled to all users' do
        expect(curtain.opened?('feature')).to be false
      end
    end
  end

  describe '#users' do
    context 'when there are users enabled' do
      before do
        subject.add_users('feature', users)
      end

      it 'should return list with all added users' do
        expect(subject.users('feature').sort).to eq(users.sort)
      end
    end

    context 'when there are no users enabled' do
      it 'should return empty user list' do
        expect(subject.users('feature')).to be_empty
      end
    end
  end

  describe '#percentage' do
    context 'when percentage is any value' do
      let(:rand) { Random.new.rand(1..100) }

      before do
        subject.update_percentage('feature', rand)
      end

      it 'should return correct percentage value' do
        expect(subject.percentage('feature')).to eq(rand)
      end
    end
  end
end
