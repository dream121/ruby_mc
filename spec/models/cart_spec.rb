require 'spec_helper'

describe Cart do
  describe "validations" do
    subject { create(:cart_with_products) }

    before do
      subject.stub_chain(:user, :courses).and_return []
    end

    describe "user_id" do
      it "is required" do
        expect(subject).to_not accept_values(:user_id, nil, '', ' ')
      end
    end
  end
end
