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

  describe '#count_processed' do
    subject(:count_processed) { coin_repo.count_processed }

    context 'when multiple coins exist' do
      let!(:one_pence_coin) { Factory[:coin, :one_pence, :processed] }
      let!(:two_pence_coin) { Factory[:coin, :two_pence, :processing] }

      it 'counts only the processed coins' do
        is_expected.to be(1)
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be(0) }
    end
  end

  describe '#count_dispensed' do
    subject(:count_dispensed) { coin_repo.count_dispensed }

    context 'when multiple coins exist' do
      let!(:one_pence_coin) { Factory[:coin, :one_pence, :dispensed] }
      let!(:two_pence_coin) { Factory[:coin, :two_pence, :processing] }

      it 'counts only the dispensed coins' do
        is_expected.to be(1)
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be(0) }
    end
  end

  describe '#dispensable' do
    subject(:dispensable) { coin_repo.dispensable }

    context 'when multiple coins exist' do
      let!(:one_pence_coin_dispensed) { Factory[:coin, :one_pence, :dispensed] }
      let!(:one_pence_coin_processing) { Factory[:coin, :one_pence, :processing] }
      let!(:one_pence_coin_processed) { Factory[:coin, :one_pence, :processed] }

      it 'returns only dispensable coins' do
        is_expected.to eql([one_pence_coin_processing, one_pence_coin_processed])
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be_empty }
    end
  end

  describe '#processing' do
    subject(:processing) { coin_repo.processing }

    context 'when multiple coins exist' do
      let!(:one_pence_coin_processing) { Factory[:coin, :one_pence, :processing] }
      let!(:one_pence_coin_processed) { Factory[:coin, :one_pence, :processed] }

      it 'returns only processing coins' do
        is_expected.to eql([one_pence_coin_processing])
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be_empty }
    end
  end
end
