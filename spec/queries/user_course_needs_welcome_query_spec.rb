require 'spec_helper'

describe UserCourseNeedsWelcomeQuery do
  describe "find" do
    context "when one user course needs a welcome email" do
      before do
        Timecop.freeze(1.day.ago) do
          @uc1 = create :user_course, welcomed: false
          @uc2 = create :user_course, welcomed: true
        end
        @uc3 = create :user_course, welcomed: false
      end

      it 'finds only the user course that needs a welcome email' do
        found = UserCourseNeedsWelcomeQuery.new.find
        expect(found.to_a).to eq([@uc1])
      end
    end
  end
end
