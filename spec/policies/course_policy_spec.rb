require 'spec_helper'

describe CoursePolicy do

  subject { CoursePolicy.new(current_user, course) }

  context "for an admin" do
    let(:current_user) { build :admin }
    let(:course) { build :course }

    it { should     permit(:show)    }
    it { should     permit(:index)   }
    it { should     permit(:new)     }
    it { should     permit(:create)  }
    it { should     permit(:edit)    }
    it { should     permit(:update)  }
    it { should     permit(:destroy) }
  end

  context "for a non-admin" do
    let(:current_user) { build :user }
    let(:course) { build :course }

    it { should     permit(:show)    }
    it { should     permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
