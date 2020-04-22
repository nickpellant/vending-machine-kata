# frozen_string_literal: true

require 'spec_helper'
require 'repos/product_repo'

RSpec.describe Repos::ProductRepo do
  subject(:product_repo) { described_class.new }

  describe '#all' do
    subject(:all) { product_repo.all }

    let!(:all_products) { [Factory[:product], Factory[:product]] }

    it 'is expected to return all products' do
      expect(all).to eql(all_products)
    end
  end

  describe '#by_params' do
    subject(:by_params) { product_repo.by_params(params) }

    context 'when product found' do
      let(:product) { Factory[:product] }
      let(:params) { { name: product.name } }

      it 'is expected to return the product' do
        expect(by_params).to eql(product)
      end
    end

    context 'when product not found' do
      let(:params) { { name: 'Name' } }

      it { expect(by_params).to be_nil }
    end
  end

  describe '#count' do
    subject(:count) { product_repo.count }

    context 'when products exist' do
      let!(:products) { [Factory[:product]] }

      it { is_expected.to be(1) }
    end

    context 'when no products exist' do
      it { is_expected.to be(0) }
    end
  end

  describe '#exists?' do
    subject(:exists?) { product_repo.exists?(params) }

    context 'when product found' do
      let(:product) { Factory[:product] }
      let(:params) { { name: product.name } }

      it { is_expected.to be(true) }
    end

    context 'when product not found' do
      let(:params) { { name: 'Name' } }

      it { is_expected.to be(false) }
    end
  end
end
