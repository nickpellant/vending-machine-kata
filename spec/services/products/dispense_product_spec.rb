# frozen_string_literal: true

require 'spec_helper'

require 'services/products/update_product_stock'
require 'services/products/dispense_product'

RSpec.describe Services::Products::DispenseProduct do
  subject(:call) { described_class.call(product: product) }

  let(:product) { Factory.structs[:product] }

  let(:update_product_stock) { class_spy(Services::Products::UpdateProductStock) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  before do
    App.stub('services.products.update_product_stock', update_product_stock)
  end

  context 'when product data is valid' do
    before do
      allow(update_product_stock).to(
        receive(:call)
        .with(product: product, quantity_to_stock: -1)
        .and_return(product)
      )
    end

    it 'logs that the product was dispensed' do
      call

      expect(logger).to have_received(:info).with("#{product.name} product dispensed")
    end
  end

  context 'when product data is invalid' do
    before do
      allow(update_product_stock).to(
        receive(:call)
        .with(product: product, quantity_to_stock: -1)
        .and_raise(StandardError.new('Product failed to dispense'))
      )
    end

    it 'logs that the product was dispensed' do
      expect { call }.to raise_error
    end
  end
end
