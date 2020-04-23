# frozen_string_literal: true

require 'spec_helper'
require 'repos/coin_insertion_repo'

RSpec.describe Repos::CoinInsertionRepo do
  subject(:coin_insertion_repo) { described_class.new }

  describe '#count_by_coin' do
    subject(:count_by_coin) { coin_insertion_repo.count_by_coin(one_pence_coin) }

    let!(:one_pence_coin) { Factory[:coin, :one_pence] }
    let!(:two_pence_coin) { Factory[:coin, :two_pence] }

    context 'when multiple coin insertions exist' do
      let!(:one_pence_coin_insertions) { [Factory[:coin_insertion, coin_id: one_pence_coin.id]] }
      let!(:two_pence_coin_insertions) { [Factory[:coin_insertion, coin_id: two_pence_coin.id]] }

      it 'counts only the coin insertions of the passed coin' do
        is_expected.to be(1)
      end
    end

    context 'when no coins exist' do
      it { is_expected.to be(0) }
    end
  end
end
