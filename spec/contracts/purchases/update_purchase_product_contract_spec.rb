# frozen_string_literal: true

require 'spec_helper'
require 'support/shared_examples/a_contract_with_required_values'
require 'support/shared_examples/a_required_integer_schema_value'

require 'contracts/purchases/update_purchase_product_contract'

RSpec.describe Contracts::Purchases::UpdatePurchaseProductContract do
  it_behaves_like 'a contract with required values' do
    let(:required_values) { %i[product_id] }
  end

  describe '#errors[:product_id]' do
    it_behaves_like 'a required integer schema value' do
      let(:value_key) { :product_id }
    end
  end
end
