require 'spec_helper'

describe User do
  describe "validations" do

    subject { build(:user) }

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
    end

  end

  describe "#update_permissions" do
    subject { build :user }

    it 'converts string true/false values into boolean' do
      subject.permissions = {}
      subject.update_permissions('a' => 'true', 'b' => 'false', 'c' => 'foo')
      expect(subject.permissions).to eq({'a' => true, 'b' => false, 'c' => 'foo'})
    end
  end

  describe "default permissions" do
    subject { create :user }

    it 'is not an admin' do
      expect(subject.admin?).to be_false
      subject.reload
      expect(subject.admin?).to be_false
    end

    it 'can comment' do
      expect(subject.permissions['comments']).to be_true
    end
  end

  describe "#admin?" do
    subject { build(:user) }

    it 'returns true if user has admin permissions' do
      subject.permissions = { 'admin' => true }
      expect(subject.admin?).to be_true
    end

    it 'returns false if user admin permission is false' do
      subject.permissions = { 'admin' => false }
      expect(subject.admin?).to be_false
    end

    it 'returns false if user admin permission is missing' do
      subject.permissions = {}
      expect(subject.admin?).to be_false
    end
  end
end
