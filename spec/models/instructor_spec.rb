require 'spec_helper'

describe Instructor do
  describe "validations" do

    subject { build(:instructor) }

    describe "name" do
      it "is required" do
        expect(subject).to_not accept_values(:name, nil, '', ' ')
      end

      it "must be unique" do
        subject.save
        stunt_double = subject.dup
        expect(stunt_double).to_not accept_values(:name, subject.name)
      end
    end
  end
end
