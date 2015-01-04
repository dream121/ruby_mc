require 'spec_helper'

describe Order do
  subject { create(:order) }

  describe "validations" do
    describe "user_id" do
      it "is required" do
        expect(subject).to_not accept_values(:user_id, nil, '', ' ')
      end
    end
  end

  describe '#products' do
    it 'returns an array of products' do
      expect(subject.products.first).to be_a(Product)
      expect(subject.products).to eq([subject.order_products.first.product])
    end
  end
end
