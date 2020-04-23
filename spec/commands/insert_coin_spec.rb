# frozen_string_literal: true

require 'spec_helper'

require 'commands/insert_coin'

RSpec.describe Commands::InsertCoin do
  subject(:call) { described_class.call(denomination: denomination) }

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when coin found' do
    let!(:coin) { Factory[:coin, :one_pence] }

    let(:denomination) { coin.denomination }

    let(:log_coin_accepted_message) { 'Coin accepted' }

    it 'inserts the coin into the machine' do
      expect { call }.to(
        change { App['repos.coin_insertion_repo'].count_by_coin(coin) }.from(0).to(1)
      )
    end

    it 'logs that the coin was accepted' do
      call

      expect(logger).to have_received(:info).with(log_coin_accepted_message)
    end
  end

  context 'when coin not found' do
    let(:denomination) { '£5' }

    let(:log_coin_not_accepted) { 'Coin is not accepted' }

    it 'logs that the coin was not accepted' do
      call

      expect(logger).to have_received(:error).with(log_coin_not_accepted)
    end
  end
end
