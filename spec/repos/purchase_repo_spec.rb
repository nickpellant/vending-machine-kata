# frozen_string_literal: true

require 'spec_helper'
require 'repos/purchase_repo'

RSpec.describe Repos::PurchaseRepo do
  subject(:purchase_repo) { described_class.new }

  describe '#by_id' do
    subject(:by_id) { purchase_repo.by_id(purchase_id) }

    context 'when product found' do
      let(:product) { Factory[:product] }
      let(:purchase) { Factory[:purchase, product_id: product.id] }
      let(:purchase_id) { purchase.id }

      it 'is expected to return the purchase' do
        expect(by_id).to eql(purchase)
      end
    end

    context 'when purchase not found' do
      let(:purchase_id) { 0 }

      it { expect(by_id).to be_nil }
    end
  end

  describe '#active' do
    subject(:active) { purchase_repo.active }

    let(:product) { Factory[:product] }
    let!(:active_purchase) { Factory[:purchase, :active, product_id: product.id] }
    let!(:cancelled_purchase) { Factory[:purchase, :cancelled, product_id: product.id] }

    it 'is expected to return the active purchase' do
      expect(active).to eql(active_purchase)
    end
  end

  describe '#count' do
    subject(:count) { purchase_repo.count }

    context 'when purchases exist' do
      let(:product) { Factory[:product] }
      let!(:coins) { [Factory[:purchase, :active, product_id: product.id]] }

      it { is_expected.to be(1) }
    end

    context 'when no purchases exist' do
      it { is_expected.to be(0) }
    end
  end
end
