require 'spec_helper'

describe Product do
  describe "#for_course" do
    let(:product) { create :course_product }

    it "finds the product for the given course" do
      found = Product.for_course(product.course)
      expect(found).to be_a(Product)
      expect(found).to eq(product)
    end
  end
end
