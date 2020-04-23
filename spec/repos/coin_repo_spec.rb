# frozen_string_literal: true

require 'spec_helper'
require 'repos/coin_repo'

RSpec.describe Repos::CoinRepo do
  subject(:coin_repo) { described_class.new }

  describe '#count_by_denomination' do
    subject(:count_by_denomination) { coin_repo.count_by_denomination(denomination) }

    let(:denomination) { '1p' }

    context 'when multiple coins exist' do
      let!(:one_pence_coin) { Factory[:coin, :one_pence] }
      let!(:two_pence_coin) { Factory[:coin, :two_pence] }

      it 'counts only the coins of the correct denomination' do
        is_expected.to be(1)
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be(0) }
    end
  end

  describe '#processing' do
    subject(:processing) { coin_repo.processing }

    context 'when multiple coins exist' do
      let!(:one_pence_coin_processing) { Factory[:coin, :one_pence, :processing] }
      let!(:one_pence_coin_received) { Factory[:coin, :one_pence, :received] }

      it 'returns only processing coins' do
        is_expected.to eql([one_pence_coin_processing])
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be_empty }
    end
  end
end
