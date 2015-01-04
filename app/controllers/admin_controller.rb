class AdminController < ApplicationController
  before_filter :require_login
  after_filter :verify_authorized
  after_filter :verify_policy_scoped, only: :index
end
