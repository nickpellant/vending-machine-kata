# frozen_string_literal: true

require 'spec_helper'

require 'commands/load_coin'

RSpec.describe Commands::LoadCoin do
  subject(:call) do
    described_class.call(denomination: denomination, quantity_to_load: quantity_to_load)
  end

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when denomination accepted' do
    let(:denomination) { '1p' }
    let(:quantity_to_load) { 1 }

    let(:log_coins_loaded) { "#{quantity_to_load} #{denomination} coins loaded" }

    it 'loads the coins into the machine' do
      expect { call }.to(
        change { App['repos.coin_repo'].count_by_denomination(denomination) }
        .from(0)
        .to(quantity_to_load)
      )
    end

    it 'logs that the coin load was updated' do
      call

      expect(logger).to have_received(:info).with(log_coins_loaded)
    end
  end

  context 'when denomination not accepted' do
    let(:denomination) { '£5' }
    let(:quantity_to_load) { 1 }

    let(:log_coins_not_accepted_message) do
      "#{denomination} coin is not accepted"
    end

    it 'logs that the coin was not found' do
      call

      expect(logger).to have_received(:error).with(log_coins_not_accepted_message)
    end
  end
end
