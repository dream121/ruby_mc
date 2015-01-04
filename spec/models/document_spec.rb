require 'spec_helper'

describe Document do
  describe "validations" do

    before do
      stub_request(:head, %r{test\.s3\.amazonaws\.com}).to_return status: 404, body: ''
    end

    subject { build(:document) }

    describe "title" do
      it "is required" do
        expect(subject).to_not accept_values(:title, nil)
      end
    end
  end
end
