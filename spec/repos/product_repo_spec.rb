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
end
