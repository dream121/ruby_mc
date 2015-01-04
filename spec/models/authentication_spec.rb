require 'spec_helper'

describe Authentication do
  describe "validations" do

    subject { build :authentication }

    describe "provider" do
      it "is required" do
        expect(subject).to_not accept_values(:provider, nil, '', ' ')
      end
    end

    describe "uid" do
      it "is required" do
        expect(subject).to_not accept_values(:uid, nil, '', ' ')
      end
    end
  end
end
