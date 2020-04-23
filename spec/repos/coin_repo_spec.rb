# frozen_string_literal: true

require 'spec_helper'
require 'repos/coin_repo'

RSpec.describe Repos::CoinRepo do
  subject(:coin_repo) { described_class.new }

  describe '#all' do
    subject(:all) { coin_repo.all }

    let!(:all_coins) { [Factory[:coin, :one_pence], Factory[:coin, :two_pence]] }

    it 'is expected to return all coins' do
      expect(all).to eql(all_coins)
    end
  end

  describe '#by_denomination' do
    subject(:by_denomination) { coin_repo.by_denomination(denomination) }
    let(:denomination) { '1p' }

    context 'when coin found' do
      let!(:coin) { Factory[:coin, :one_pence] }

      it 'is expected to return the coin' do
        expect(by_denomination).to eql(coin)
      end
    end

    context 'when coin not found' do
      it { expect(by_denomination).to be_nil }
    end
  end

  describe '#count' do
    subject(:count) { coin_repo.count }

    context 'when coins exist' do
      let!(:coins) { [Factory[:coin, :one_pence]] }

      it { is_expected.to be(1) }
    end

    context 'when no coins exist' do
      it { is_expected.to be(0) }
    end
  end

  describe '#exists?' do
    subject(:exists?) { coin_repo.exists?(params) }

    context 'when coin found' do
      let(:coin) { Factory[:coin, :one_pence] }
      let(:params) { { denomination: coin.denomination } }

      it { is_expected.to be(true) }
    end

    context 'when coin not found' do
      let(:params) { { denomination: '1p' } }

      it { is_expected.to be(false) }
    end
  end
end
