# frozen_string_literal: true

require 'spec_helper'

require 'commands/vending_machine/stock_product'

RSpec.describe Commands::VendingMachine::StockProduct do
  subject(:call) do
    described_class.call(name: name, price: price, quantity_to_stock: quantity_to_stock)
  end

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when product found and adding stock to product' do
    let!(:product) { Factory[:product] }

    let(:name) { product.name }
    let(:price) { product.price }
    let(:quantity_to_stock) { 1 }
    let(:new_quantity_in_stock) { product.quantity_in_stock + quantity_to_stock }

    let(:log_product_stock_updated_message) do
      "'#{name}' stock changed from #{product.quantity_in_stock} to #{new_quantity_in_stock}"
    end

    it 'updates the product quantity in stock' do
      expect { call }.to(
        change { App['repos.product_repo'].by_params(name: name, price: price).quantity_in_stock }
        .from(product.quantity_in_stock)
        .to(new_quantity_in_stock)
      )
    end

    it 'logs that the product stock was updated' do
      call

      expect(logger).to have_received(:info).with(log_product_stock_updated_message)
    end
  end

  context 'when product found and removing more stock than product has' do
    let!(:product) { Factory[:product] }

    let(:name) { product.name }
    let(:price) { product.price }
    let(:quantity_to_stock) { -(product.quantity_in_stock + product.quantity_in_stock + 1) }

    let(:log_product_stock_update_failed_validation_message) do
      "Attempting to update stock for '#{name}' led to a validation error"
    end

    it 'does not change the product quantity in stock' do
      expect { call }.not_to(
        change { App['repos.product_repo'].by_params(name: name, price: price).quantity_in_stock }
        .from(product.quantity_in_stock)
      )
    end

    it 'logs that the product stock update failed validation' do
      call

      expect(logger).to(
        have_received(:error).with(log_product_stock_update_failed_validation_message)
      )
    end
  end

  context 'when product not found and data is valid' do
    let(:name) { Factory.structs[:product].name }
    let(:price) { Factory.structs[:product].price }
    let(:quantity_to_stock) { 1 }

    let(:log_product_created_message) do
      "#{quantity_to_stock} of '#{name}' stocked at #{price.to_f}/unit"
    end

    before do
      allow(logger).to receive(:info).with(log_product_created_message)
    end

    it 'creates a product' do
      call

      product_exists = App['repos.product_repo'].exists?(
        name: name, price: price, quantity_in_stock: quantity_to_stock
      )

      expect(product_exists).to be(true)
    end

    it 'logs that the product was created' do
      call

      expect(logger).to have_received(:info).with(log_product_created_message)
    end
  end

  context 'when product not found and data is invalid' do
    let(:name) { '' }
    let(:price) { -1.to_d }
    let(:quantity_to_stock) { 0 }

    let(:log_product_creation_failed_validation) do
      "Attempting to create '#{name}' led to a validation error"
    end

    it 'creates no products' do
      expect { call }.not_to change(App['repos.product_repo'], :count).from(0)
    end

    it 'logs that the product creation failed validation' do
      call

      expect(logger).to have_received(:error).with(log_product_creation_failed_validation)
    end
  end
end
