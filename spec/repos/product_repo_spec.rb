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
end
