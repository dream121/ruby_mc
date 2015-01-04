require 'spec_helper'

describe Message do
  describe "validations" do

    subject { Message.new }

    describe "subject" do
      it "is required" do
        expect(subject).to_not accept_values(:subject, nil, '', ' ')
      end
    end

    describe "body" do
      it "is required" do
        expect(subject).to_not accept_values(:body, nil, '', ' ')
      end
    end

    describe "from" do
      it "is required" do
        expect(subject).to_not accept_values(:from, nil, '', ' ')
      end
    end

    describe "to" do
      it "is required" do
        expect(subject).to_not accept_values(:to, nil, '', ' ')
      end
    end

  end
end
