class NotificationsController < ApplicationController
	layout "watch"

	def index
		@user = @current_user.decorate
		if request.xhr?
			@comment_notifications = @comment_notifications.order("created_at desc")
		end
		respond_to do |format|
			format.html
			format.js
		end
	end
end
