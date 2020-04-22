# frozen_string_literal: true

require 'spec_helper'

require 'contracts/products/update_product_stock_contract'
require 'repos/product_repo'
require 'services/products/update_product_stock'

RSpec.describe Services::Products::UpdateProductStock do
  subject(:call) { described_class.call(product: product, quantity_to_stock: quantity_to_stock) }

  let(:product) { Factory.structs[:product] }

  let(:update_product_stock_contract) do
    instance_spy(Contracts::Products::UpdateProductStockContract)
  end
  let(:product_repo) { instance_spy(Repos::ProductRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(update_product_stock_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub('contracts.products.update_product_stock_contract', update_product_stock_contract)
    App.stub('repos.product_repo', product_repo)
  end

  context 'when change to quantity in stock is valid' do
    let(:quantity_to_stock) { 1 }
    let(:new_quantity_in_stock) { product.quantity_in_stock + quantity_to_stock }
    let(:unvalidated_params) { { quantity_in_stock: new_quantity_in_stock } }
    let(:validated_params) { unvalidated_params }

    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(product_repo).to receive(:update).with(product.id, validated_params).and_return(product)
    end

    it 'validates the product data' do
      call

      expect(update_product_stock_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'updates the product' do
      call

      expect(product_repo).to have_received(:update).with(product.id, validated_params)
    end

    it 'returns the created product' do
      expect(call).to be(product)
    end
  end

  context 'when change to quantity in stock is invalid' do
    let(:quantity_to_stock) { -(product.quantity_in_stock + 1) }
    let(:new_quantity_in_stock) { -1 }
    let(:unvalidated_params) { { quantity_in_stock: new_quantity_in_stock } }

    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the product data' do
      call

      expect(update_product_stock_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'does not update the product' do
      call

      expect(product_repo).not_to have_received(:update)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
