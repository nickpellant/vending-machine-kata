# frozen_string_literal: true

require 'spec_helper'

require 'contracts/products/create_product_contract'
require 'repos/product_repo'
require 'services/products/create_product'

RSpec.describe Services::Products::CreateProduct do
  subject(:call) do
    described_class.call(name: name, price: price, quantity_in_stock: quantity_in_stock)
  end

  let(:create_product_contract) { instance_spy(Contracts::Products::CreateProductContract) }
  let(:product_repo) { instance_spy(Repos::ProductRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(create_product_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub('contracts.products.create_product_contract', create_product_contract)
    App.stub('repos.product_repo', product_repo)
  end

  context 'when product data is valid' do
    let(:product) { Factory.structs[:product] }

    let(:name) { product.name }
    let(:price) { product.price }
    let(:quantity_in_stock) { product.quantity_in_stock }

    let(:unvalidated_params) { { name: name, price: price, quantity_in_stock: quantity_in_stock } }
    let(:validated_params) { unvalidated_params }

    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(product_repo).to receive(:create).with(validated_params).and_return(product)
    end

    it 'validates the product data' do
      call

      expect(create_product_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'creates the product' do
      call

      expect(product_repo).to have_received(:create).with(validated_params)
    end

    it 'returns the created product' do
      expect(call).to be(product)
    end
  end

  context 'when product data is invalid' do
    let(:product) { Factory.structs[:product] }

    let(:name) { '' }
    let(:price) { product.price }
    let(:quantity_in_stock) { product.quantity_in_stock }

    let(:unvalidated_params) { { name: name, price: price, quantity_in_stock: quantity_in_stock } }

    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the product data' do
      call

      expect(create_product_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'does not create a product' do
      call

      expect(product_repo).not_to have_received(:create)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
