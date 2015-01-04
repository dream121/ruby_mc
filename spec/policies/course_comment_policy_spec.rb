require 'spec_helper'

describe CourseCommentPolicy do

  let(:admin) { create :admin }
  let(:user_course) { create :user_course }
  let(:course) { user_course.course }
  let(:topic) { course.comments.create(comment: 'Topic 1') }
  let(:comment) { course.comments.build(comment: 'Comment 1', parent: topic) }

  context "for a comment" do
    subject { CourseCommentPolicy.new(current_user, comment) }

    context "for an enrolled user" do
      let(:current_user) { user_course.user }

      it { should permit(:create)      }
      it { should_not permit(:new)     }
      it { should_not permit(:edit)    }
      it { should     permit(:update)  }
      it { should_not permit(:destroy) }
      it { should_not permit(:moderate)}
    end

    context "for an admin" do
      let(:current_user) { admin }

      it { should permit(:create)      }
      it { should permit(:new)         }
      it { should permit(:edit)        }
      it { should permit(:update)      }
      it { should permit(:destroy)     }
      it { should permit(:moderate)    }
    end
  end

  context "for a topic" do
    subject { CourseCommentPolicy.new(current_user, topic) }

    context "for an enrolled user" do
      let(:current_user) { user_course.user }

      it { should_not permit(:create)  }
      it { should_not permit(:new)     }
      it { should_not permit(:edit)    }
      it { should_not permit(:update)  }
      it { should_not permit(:destroy) }
      it { should_not permit(:moderate)}
    end

    context "for an admin" do
      let(:current_user) { admin }

      it { should permit(:create)      }
      it { should permit(:new)         }
      it { should permit(:edit)        }
      it { should permit(:update)      }
      it { should permit(:destroy)     }
    end
  end
end
