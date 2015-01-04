require 'spec_helper'

describe CourseReviewPolicy do

  let(:admin) { create :admin }
  let(:user_course) { create :user_course }
  let(:course) { user_course.course }
  let(:user) { user_course.user }
  let(:review) { course.reviews.build }

  context "for a course" do
    subject { CourseReviewPolicy.new(current_user, review) }

    context "for an enrolled user" do
      let(:current_user) { user }

      it { should_not permit(:index)   }
      it { should permit(:new)         }
      it { should permit(:create)      }
      it { should_not permit(:edit)    }
      it { should_not permit(:update)  }
      it { should_not permit(:destroy) }
    end

    context "for a non-enrolled user" do
      let(:current_user) { create :user }

      it { should_not permit(:index)   }
      it { should_not permit(:new)     }
      it { should_not permit(:create)  }
      it { should_not permit(:edit)    }
      it { should_not permit(:update)  }
      it { should_not permit(:destroy) }
    end

    context "for an admin" do
      let(:current_user) { admin }

      it { should permit(:index)       }
      it { should permit(:new)         }
      it { should permit(:create)      }
      it { should permit(:edit)        }
      it { should permit(:update)      }
      it { should permit(:destroy)     }
    end
  end
end
