require 'spec_helper'

describe ChapterPolicy do

  let(:course) { build :course }
  let(:chapter) { build :chapter, course: course }

  subject { ChapterPolicy.new(current_user, chapter) }

  context "for an admin" do
    let(:current_user) { build :admin }
    it { should     permit(:show)    }
    it { should     permit(:watch)   }
    it { should_not permit(:index)   }
    it { should     permit(:new)     }
    it { should     permit(:create)  }
    it { should     permit(:edit)    }
    it { should     permit(:update)  }
    it { should     permit(:destroy) }
  end

  context "for a non-admin" do
    let(:current_user) { build :user }

    it { should     permit(:show)    }
    it { should_not permit(:watch)   }
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
