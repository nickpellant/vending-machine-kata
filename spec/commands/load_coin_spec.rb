# frozen_string_literal: true

require 'spec_helper'

require 'commands/load_coin'

RSpec.describe Commands::LoadCoin do
  subject(:call) do
    described_class.call(denomination: denomination, quantity_to_load: quantity_to_load)
  end

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when coin found' do
    let!(:coin) { Factory[:coin, :one_pence] }

    let(:denomination) { coin.denomination }
    let(:quantity_to_load) { 1 }

    let(:log_coins_loaded) do
      "#{quantity_to_load} #{denomination} coins loaded"
    end

    it 'loads the coins into the machine' do
      expect { call }.to(
        change { App['repos.coin_insertion_repo'].count_by_coin(coin) }.from(0).to(quantity_to_load)
      )
    end

    it 'logs that the coin load was updated' do
      call

      expect(logger).to have_received(:info).with(log_coins_loaded)
    end
  end

  context 'when coin not found' do
    let(:denomination) { '£5' }
    let(:quantity_to_load) { 1 }

    let(:log_coin_not_found_message) do
      "#{denomination} coin is not accepted"
    end

    it 'logs that the coin was not found' do
      call

      expect(logger).to have_received(:error).with(log_coin_not_found_message)
    end
  end
end
