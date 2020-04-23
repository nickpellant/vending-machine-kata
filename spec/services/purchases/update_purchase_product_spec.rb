# frozen_string_literal: true

require 'spec_helper'

require 'contracts/purchases/update_purchase_product_contract'
require 'repos/purchase_repo'
require 'services/purchases/update_purchase_product'

RSpec.describe Services::Purchases::UpdatePurchaseProduct do
  subject(:call) { described_class.call(product: product, purchase: purchase) }

  let(:product) { Factory.structs[:product] }
  let(:purchase) { Factory.structs[:purchase] }

  let(:unvalidated_params) { { product_id: product.id } }
  let(:validated_params) { unvalidated_params }

  let(:update_purchase_product_contract) do
    instance_spy(Contracts::Purchases::UpdatePurchaseProductContract)
  end
  let(:purchase_repo) { instance_spy(Repos::PurchaseRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(update_purchase_product_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub(
      'contracts.purchases.update_purchase_product_contract',
      update_purchase_product_contract
    )
    App.stub('repos.purchase_repo', purchase_repo)
  end

  context 'when change to purchase product is valid' do
    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(purchase_repo).to(
        receive(:update).with(purchase.id, validated_params).and_return(purchase)
      )
    end

    it 'validates the purchase data' do
      call

      expect(update_purchase_product_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'updates the purchase' do
      call

      expect(purchase_repo).to have_received(:update).with(purchase.id, validated_params)
    end

    it 'returns the updated purchase' do
      expect(call).to be(purchase)
    end
  end

  context 'when change to purchase product is invalid' do
    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the purchase data' do
      call

      expect(update_purchase_product_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'does not update the purchase' do
      call

      expect(purchase_repo).not_to have_received(:update)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
