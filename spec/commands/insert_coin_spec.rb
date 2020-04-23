# frozen_string_literal: true

require 'spec_helper'

require 'commands/insert_coin'

RSpec.describe Commands::InsertCoin do
  subject(:call) { described_class.call(denomination: denomination) }

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when denomination accepted' do
    let!(:denomination) { '1p' }

    let(:log_coin_accepted_message) { 'Coin accepted' }

    it 'inserts the coin into the machine' do
      expect { call }.to(
        change { App['repos.coin_repo'].count_by_denomination(denomination) }.from(0).to(1)
      )
    end

    it 'logs that the coin was accepted' do
      call

      expect(logger).to have_received(:info).with(log_coin_accepted_message)
    end
  end

  context 'when denomination not accepted' do
    let(:denomination) { '£5' }

    let(:log_coin_not_accepted) { 'Coin is not accepted' }

    it 'logs that the coin was not accepted' do
      call

      expect(logger).to have_received(:error).with(log_coin_not_accepted)
    end
  end
end
