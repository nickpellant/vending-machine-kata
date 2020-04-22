# frozen_string_literal: true

require 'spec_helper'
require 'support/shared_examples/a_contract_with_required_values'
require 'support/shared_examples/a_required_integer_schema_value'

require 'contracts/products/update_product_stock_contract'

RSpec.describe Contracts::Products::UpdateProductStockContract do
  it_behaves_like 'a contract with required values' do
    let(:required_values) { %i[quantity_in_stock] }
  end

  describe '#errors[:quantity_in_stock]' do
    it_behaves_like 'a required integer schema value' do
      let(:value_key) { :quantity_in_stock }

      context 'when value is less than zero' do
        let(:params) { { value_key => -1 } }

        it { is_expected.to eql(['must be greater than or equal to zero']) }
      end
    end
  end
end
