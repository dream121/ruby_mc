require 'spec_helper'

describe ImagePolicy do

  subject { ImagePolicy.new(current_user, image) }

  context "for an admin" do
    let(:current_user) { build :admin }
    let(:image) { build :image }

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
    let(:image) { build :image }

    it { should_not permit(:show)    }
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
