require 'spec_helper'

describe ExperimentValue do
  describe "validations" do

    subject { build(:experiment_value) }

    describe "experiment" do
      it "is required" do
        expect(subject).to_not accept_values(:experiment, nil, '', ' ')
      end
    end

    describe "variation" do
      it "is required" do
        expect(subject).to_not accept_values(:variation, nil, '', ' ')
      end
    end

    describe "key" do
      it "is required" do
        expect(subject).to_not accept_values(:key, nil, '', ' ')
      end
    end

    describe "value" do
      it "is required" do
        expect(subject).to_not accept_values(:value, nil, '', ' ')
      end
    end

  end
end
