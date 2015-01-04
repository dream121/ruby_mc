class Api::V1::BaseController < ApplicationController
  before_filter :require_login
  before_filter :default_format_json
  after_filter :verify_authorized

  def user_not_authorized(e)
    head :unauthorized
  end

  def default_format_json
    request.format = "json" unless params[:format]
  end

  private

  def require_login
    unless logged_in?
      head :unauthorized
    end
  end

  def set_search_result_vars(results)
    @results          = results[:result_set]
    @prev_page_url    = results[:prev_page_url]
    @next_page_url    = results[:next_page_url]
    @last_id          = results[:last_id]
    @first_id         = results[:first_id]
    @total_items      = results[:total_items]
    @items_left       = results[:items_left]
    @items_before     = results[:items_before]
    @focus_id         = results[:focus_id]
    @focus_parent_id  = results[:focus_parent_id]
    @focused          = results[:focused]
    @requester_id     = results[:requester_id]
  end
end
