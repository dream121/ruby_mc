require 'spec_helper'

describe CartProduct do
  subject { build(:cart_product) }

  describe "cart_id" do
    it "is required" do
      expect(subject).to_not accept_values(:cart_id, nil, '', ' ')
    end
  end

  describe "product_id" do
    it "is required" do
      expect(subject).to_not accept_values(:product_id, nil, '', ' ')
    end
  end
end
