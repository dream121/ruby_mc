require 'spec_helper'

describe OrderProduct do
  subject { build(:order_product) }

  describe "product_id" do
    it "is required" do
      expect(subject).to_not accept_values(:product_id, nil, '', ' ')
    end
  end
end
