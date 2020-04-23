# frozen_string_literal: true

require 'spec_helper'
require 'entities/coin'

RSpec.describe Entities::Coin do
  describe '#value' do
    subject(:value) { coin.value }
    let(:coin) { Factory.structs[:coin, :one_pence] }

    it { is_expected.to eql(0.01.to_d) }
  end
end
