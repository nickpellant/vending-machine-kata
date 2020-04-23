# frozen_string_literal: true

require 'spec_helper'

require 'repos/purchase_repo'
require 'services/purchases/find_or_create_active_purchase'

RSpec.describe Services::Purchases::FindOrCreateActivePurchase do
  subject(:call) { described_class.call }

  let(:purchase_repo) { instance_spy(Repos::PurchaseRepo) }

  before do
    App.stub('repos.purchase_repo', purchase_repo)
  end

  context 'when active purchase found' do
    let(:existing_purchase) { Factory.structs[:purchase] }

    before do
      allow(purchase_repo).to receive(:active).and_return(existing_purchase)
    end

    it 'queries for the active purchase' do
      call

      expect(purchase_repo).to have_received(:active)
    end

    it 'does not create a new active purchase' do
      call

      expect(purchase_repo).not_to have_received(:create)
    end

    it 'returns the active purchase' do
      expect(call).to eql(existing_purchase)
    end
  end

  context 'when active purchase not found' do
    let(:new_purchase) { Factory.structs[:purchase] }

    before do
      allow(purchase_repo).to receive(:active).and_return(nil)
      allow(purchase_repo).to receive(:create).with(state: :active).and_return(new_purchase)
    end

    it 'queries for the active purchase' do
      call

      expect(purchase_repo).to have_received(:active)
    end

    it 'creates a new active purchase' do
      call

      expect(purchase_repo).to have_received(:create).with(state: :active)
    end

    it 'returns the active purchase' do
      expect(call).to eql(new_purchase)
    end
  end
end
