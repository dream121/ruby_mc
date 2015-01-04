require 'spec_helper'

describe ImagePolicy do

  subject { DocumentPolicy.new(current_user, document) }

  context "for an admin" do
    let(:current_user) { build :admin }
    let(:document) { build :document }
    before do
      document.document.stub(:file?).and_return true
    end

    it { should     permit(:download)}
    it { should     permit(:index)   }
    it { should     permit(:new)     }
    it { should     permit(:create)  }
    it { should     permit(:edit)    }
    it { should     permit(:update)  }
    it { should     permit(:destroy) }
  end

  context "for a non-admin who has not purchased a course" do
    let(:current_user) { build :user }
    let(:document) { build :document }

    it { should_not permit(:download)}
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end

  context "for a user who has purchased a course" do
    let(:user_course) { create :user_course }
    let(:current_user) { user_course.user }
    let(:document) { build(:document, documentable: user_course.course) }

    before do
      document.document.stub(:file?).and_return true
    end

    it { should permit(:download)    }
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end

  context "for a non-logged in user" do
    let(:current_user) { false }
    let(:document) { build :document }

    it { should_not permit(:download)}
    it { should_not permit(:index)   }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end
end
