require 'spec_helper'

describe Identity do
  describe "validations" do

    subject { build(:identity) }

    describe "email" do
      it "is required" do
        expect(subject).to_not accept_values(:email, nil, '', ' ')
      end

      it "must be properly formatted" do
        expect(subject).to     accept_values(:email, 'a@b.com', 'a@b.c.com')
        expect(subject).to_not accept_values(:email, 'a@b', 'a.b.com')
      end

      it "must be unique" do
        subject.save
        stunt_double = subject.dup
        expect(stunt_double).to_not accept_values(:email, subject.email)
      end

      it "must not have an existing user with the same email" do
        u = create(:user)
        expect(subject).to_not accept_values(:email, u.email)
      end
    end
  end
end
