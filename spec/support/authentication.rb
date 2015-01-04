module ControllerAuthenticationHelpers
  def sign_in(user)
    controller.stub(:current_user).and_return user
    controller.stub(:logged_in?).and_return true
  end
end

module FeatureAuthenticationHelpers
  def sign_in(user = nil)
    user ||= create :user
    ApplicationController.any_instance.stub(:current_user).and_return user
    ApplicationController.any_instance.stub(:logged_in?).and_return true
  end
end

RSpec.configure do |config|
  config.include ControllerAuthenticationHelpers, type: :controller
  config.include FeatureAuthenticationHelpers, type: :feature
end
