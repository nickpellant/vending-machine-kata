# frozen_string_literal: true

require 'spec_helper'

require 'commands/confirm_purchase'

RSpec.describe Commands::ConfirmPurchase do
  subject(:call) { described_class.call }

  let(:logger) { instance_spy(Logger) }
  before do
    App.stub('logger', logger)
  end

  context 'when product not selected' do
    let(:log_product_not_selected_message) { 'Product not selected to purchase' }

    it 'logs that the no product was selected to purchase' do
      call

      expect(logger).to have_received(:error).with(log_product_not_selected_message)
    end
  end

  context 'when product selected but insufficient money' do
    let(:money_required) { 0.5.to_d }
    let(:product) { Factory[:product, quantity_in_stock: 1, price: money_required] }
    let!(:purchase) { Factory[:purchase, :active, product_id: product.id] }

    let(:log_insufficient_money_message) do
      "Insufficient money inserted; £#{money_required.to_f} still required to complete purchase"
    end

    it 'logs that there is insufficient money to complete purchase' do
      call

      expect(logger).to have_received(:error).with(log_insufficient_money_message)
    end
  end

  context 'when product selected and no change to dispense' do
    let(:product) { Factory[:product, quantity_in_stock: 1, price: 0.5.to_d] }
    let!(:purchase) { Factory[:purchase, :active, product_id: product.id] }

    let!(:coins) do
      [
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :ten_pence, :processing]
      ]
    end

    it 'transitions the purchase state to complete' do
      call

      updated_purchase = App['repos.purchase_repo'].by_id(purchase.id)
      expect(updated_purchase).to be_complete
    end

    it 'reduces the quantity in stock of the product by one' do
      call

      updated_product = App['repos.product_repo'].by_id(product.id)
      expect(updated_product.quantity_in_stock).to be(0)
    end

    it 'transitions any processing coins to processed' do
      expect { call }.to change { App['repos.coin_repo'].count_processed }.from(0).to(3)
    end

    it 'logs product dispensed' do
      call

      expect(logger).to have_received(:info).with("#{product.name} product dispensed")
    end

    it 'logs no change to dispense' do
      call

      expect(logger).to have_received(:info).with('No change to dispense')
    end
  end

  context 'when product selected and change to dispense but not enough coins' do
    let(:product) { Factory[:product, quantity_in_stock: 1, price: 0.5.to_d] }
    let!(:purchase) { Factory[:purchase, :active, product_id: product.id] }

    let!(:coins) do
      [
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :twenty_pence, :processing]
      ]
    end

    it 'transitions the purchase state to complete' do
      call

      updated_purchase = App['repos.purchase_repo'].by_id(purchase.id)
      expect(updated_purchase).to be_complete
    end

    it 'reduces the quantity in stock of the product by one' do
      call

      updated_product = App['repos.product_repo'].by_id(product.id)
      expect(updated_product.quantity_in_stock).to be(0)
    end

    it 'transitions any processing coins to processed' do
      expect { call }.to change { App['repos.coin_repo'].count_processed }.from(0).to(3)
    end

    it 'logs product dispensed' do
      call

      expect(logger).to have_received(:info).with("#{product.name} product dispensed")
    end

    it 'logs change dispensed' do
      call

      expect(logger).to have_received(:info).with('0.0 of owed 0.1 change dispensed []')
    end
  end

  context 'when product selected and change to dispense with coins available' do
    let(:product) { Factory[:product, quantity_in_stock: 1, price: 0.5.to_d] }
    let!(:purchase) { Factory[:purchase, :active, product_id: product.id] }

    let!(:coins) do
      [
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :twenty_pence, :processing],
        Factory[:coin, :ten_pence, :processed]
      ]
    end

    it 'transitions the purchase state to complete' do
      call

      updated_purchase = App['repos.purchase_repo'].by_id(purchase.id)
      expect(updated_purchase).to be_complete
    end

    it 'reduces the quantity in stock of the product by one' do
      call

      updated_product = App['repos.product_repo'].by_id(product.id)
      expect(updated_product.quantity_in_stock).to be(0)
    end

    it 'transitions any processing coins to processed' do
      expect { call }.to change { App['repos.coin_repo'].count_processed }.from(1).to(3)
    end

    it 'transitions dispensing coins to dispensed' do
      expect { call }.to change { App['repos.coin_repo'].count_dispensed }.from(0).to(1)
    end

    it 'logs product dispensed' do
      call

      expect(logger).to have_received(:info).with("#{product.name} product dispensed")
    end

    it 'logs change dispensed' do
      call

      expect(logger).to have_received(:info).with('0.1 of owed 0.1 change dispensed [10p]')
    end
  end
end
