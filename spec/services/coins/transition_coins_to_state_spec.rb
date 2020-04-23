# frozen_string_literal: true

require 'spec_helper'

require 'repos/coin_repo'
require 'services/coins/transition_coins_to_state'

RSpec.describe Services::Coins::TransitionCoinsToState do
  subject(:call) { described_class.call(coins: coins, state: state) }

  let(:coin_1) { Factory.structs[:coin, :processing] }
  let(:coin_2) { Factory.structs[:coin, :processed] }
  let(:coin_ids) { [coin_1.id, coin_2.id] }

  let(:coins) { [coin_1, coin_2] }
  let(:state) { 'processed' }

  let(:coin_repo) { instance_spy(Repos::CoinRepo) }

  before do
    App.stub('repos.coin_repo', coin_repo)
  end

  it 'updates all coins to new state' do
    call

    expect(coin_repo).to have_received(:update).with(coin_ids, state: state)
  end
end
