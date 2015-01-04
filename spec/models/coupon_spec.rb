require 'spec_helper'

describe Coupon do
  describe "validations" do

    subject { build(:coupon) }

    describe "code" do
      it "is required" do
        expect(subject).to_not accept_values(:code, nil, '', ' ')
      end
    end

    describe "max_redemptions" do
      it "is required" do
        expect(subject).to_not accept_values(:max_redemptions, nil, '', ' ')
      end
    end

    describe "course_id" do
      it "is required" do
        expect(subject).to_not accept_values(:course_id, nil, '', ' ')
      end
    end

  end
end
