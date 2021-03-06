# frozen_string_literal: true

require 'spec_helper'

require 'commands/select_product'

RSpec.describe Commands::SelectProduct do
  subject(:call) { described_class.call(product_name: product_name) }

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when product found and no active purchase exists' do
    let!(:product) { Factory[:product] }
    let(:product_name) { product.name }

    let(:log_product_selected_message) { 'Product selected for purchase' }

    it 'creates an active purchase' do
      expect { call }.to(
        change { App['repos.purchase_repo'].count }.from(0).to(1)
      )
    end

    it 'selects the product to purchase' do
      call

      expect(App['repos.purchase_repo'].active.product_id).to eql(product.id)
    end

    it 'logs that the product was selected' do
      call

      expect(logger).to have_received(:info).with(log_product_selected_message)
    end
  end

  context 'when product in stock and an active purchase exists' do
    let!(:new_product_to_purchase) { Factory[:product, quantity_in_stock: 1] }
    let!(:existing_product_to_purchase) { Factory[:product, quantity_in_stock: 1] }
    let!(:purchase) { Factory[:purchase, :active, product_id: existing_product_to_purchase.id] }

    let(:product_name) { new_product_to_purchase.name }

    let(:log_product_selected_message) { 'Product selected for purchase' }

    it 'does not create a new active purchase' do
      expect { call }.not_to(
        change { App['repos.purchase_repo'].count }.from(1)
      )
    end

    it 'selects the new product to purchase' do
      call

      expect(App['repos.purchase_repo'].active.product_id).to eql(new_product_to_purchase.id)
    end

    it 'logs that the product was selected' do
      call

      expect(logger).to have_received(:info).with(log_product_selected_message)
    end
  end

  context 'when product found but is out of stock' do
    let!(:product) { Factory[:product, quantity_in_stock: 0] }
    let(:product_name) { product.name }

    let(:log_product_out_of_stock_message) { 'Product out of stock' }

    it 'does not creates a purchase' do
      expect { call }.not_to(
        change { App['repos.purchase_repo'].count }.from(0)
      )
    end

    it 'logs that the product is out of stock' do
      call

      expect(logger).to have_received(:info).with(log_product_out_of_stock_message)
    end
  end
end
