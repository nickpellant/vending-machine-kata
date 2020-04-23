# frozen_string_literal: true

require 'spec_helper'
require 'entities/purchase'

RSpec.describe Entities::Purchase do
  subject(:purchase) { described_class.new }

  describe '#product?' do
    subject(:product?) { purchase.product? }

    context 'when purchase has product' do
      let(:purchase) { Factory.structs[:purchase, product_id: 1] }
      it { is_expected.to be(true) }
    end

    context 'when purchase has no product' do
      let(:purchase) { Factory.structs[:purchase, product_id: nil] }
      it { is_expected.to be(false) }
    end
  end
end
