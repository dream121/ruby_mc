require 'spec_helper'

describe InstructorPolicy do

  subject { InstructorPolicy.new(current_user, instructor) }

  context "for an admin" do
    let(:current_user) { build :admin }
    let(:instructor) { build :instructor }

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
    let(:instructor) { build :instructor }

    it { should_not permit(:show)    }
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
