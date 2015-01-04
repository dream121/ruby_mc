require 'spec_helper'

describe Chapter do
  describe "validations" do

    subject { build(:chapter) }

    describe "title" do
      it "is required" do
        expect(subject).to_not accept_values(:title, nil, '', ' ')
      end
    end

    describe "duration" do

      it "is required" do
        expect(subject).to_not accept_values(:duration, nil, '', ' ')
      end

      it "must be well formed" do
        expect(subject).to     accept_values(:duration, '3:59', '59:59', '5')
        expect(subject).to_not accept_values(:duration, '3:99', '70:59', '5 minutes')
      end
    end

  end
end
