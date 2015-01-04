require 'spec_helper'

describe UserPolicy do

  subject { UserPolicy.new(current_user, user) }

  context "for an admin" do
    let(:current_user) { build :admin }
    let(:user) { build :user }

    it { should     permit(:show)    }
    it { should     permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should     permit(:edit)    }
    it { should     permit(:update)  }
    it { should     permit(:destroy) }
  end

  context "for a non-admin" do
    let(:current_user) { build :user }
    let(:user) { build :user }

    it { should_not permit(:show)    }
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
