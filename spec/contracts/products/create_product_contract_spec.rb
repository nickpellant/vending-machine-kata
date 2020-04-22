# frozen_string_literal: true

require 'spec_helper'
require 'support/shared_examples/a_contract_with_required_values'
require 'support/shared_examples/a_required_string_schema_value'
require 'support/shared_examples/a_required_decimal_schema_value'
require 'support/shared_examples/a_required_integer_schema_value'

require 'contracts/products/create_product_contract'

RSpec.describe Contracts::Products::CreateProductContract do
  it_behaves_like 'a contract with required values' do
    let(:required_values) { %i[name price quantity_in_stock] }
  end

  describe '#errors[:name]' do
    it_behaves_like 'a required string schema value' do
      let(:value_key) { :name }
    end
  end

  describe '#errors[:price]' do
    it_behaves_like 'a required decimal schema value' do
      let(:value_key) { :price }

      context 'when value is less than zero' do
        let(:params) { { value_key => BigDecimal('-0.1') } }

        it { is_expected.to eql(['must be greater than or equal to zero']) }
      end
    end
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
