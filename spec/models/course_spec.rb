require 'spec_helper'

describe Course do
  describe "validations" do

    subject { build(:course) }

    describe "title" do
      it "is required" do
        expect(subject).to_not accept_values(:title, nil, '', ' ')
      end

      it "must be unique" do
        subject.save
        stunt_double = subject.dup
        expect(stunt_double).to_not accept_values(:title, subject.title)
      end
    end
  end
end
