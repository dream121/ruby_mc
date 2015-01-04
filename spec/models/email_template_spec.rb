require 'spec_helper'

describe EmailTemplate do
  describe "validations" do

    subject { build(:email_template) }

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

    describe "course_id" do
      it "is required" do
        expect(subject).to_not accept_values(:course_id, nil, '', ' ')
      end
    end

  end
end
