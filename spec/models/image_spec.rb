require 'spec_helper'

describe Image do
  describe "validations" do

    before do
      stub_request(:head, %r{test\.s3\.amazonaws\.com}).to_return status: 404, body: ''
    end

    subject { build(:image) }

    describe "image" do
      it "is required" do
        expect(subject).to_not accept_values(:image, nil)
      end
    end
  end
end
