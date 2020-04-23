# frozen_string_literal: true

require 'spec_helper'
require 'repos/purchase_repo'

RSpec.describe Repos::PurchaseRepo do
  subject(:purchase_repo) { described_class.new }

  describe '#active' do
    subject(:active) { purchase_repo.active }

    let(:product) { Factory[:product] }
    let!(:active_purchase) { Factory[:purchase, :active, product_id: product.id] }
    let!(:cancelled_purchase) { Factory[:purchase, :cancelled, product_id: product.id] }

    it 'is expected to return the active purchase' do
      expect(active).to eql(active_purchase)
    end
  end
end
