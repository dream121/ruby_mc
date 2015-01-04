require 'spec_helper'

describe CourseReview do
  describe "validations" do

    subject { create(:course_review) }

    describe "rating" do
      it "is required" do
        expect(subject).to_not accept_values(:rating, nil, '', ' ')
      end

      it "is numeric" do
        expect(subject).to_not accept_values(:rating, -1, 6, 3.5, 'foo')
      end
    end

    describe "review" do
      it "is required" do
        expect(subject).to_not accept_values(:review, nil, '', ' ')
      end
    end

    describe "name" do
      it "is required" do
        expect(subject).to_not accept_values(:name, nil, '', ' ')
      end
    end

    describe "location" do
      it "is required" do
        expect(subject).to_not accept_values(:location, nil, '', ' ')
      end
    end
  end
end
