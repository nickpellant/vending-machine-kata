# frozen_string_literal: true

require 'spec_helper'
require 'entities/product'

RSpec.describe Entities::Product do
  subject(:product) { described_class.new }

  it { is_expected.to be_a(Entities::ApplicationEntity) }
end
