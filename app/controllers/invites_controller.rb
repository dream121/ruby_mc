class InvitesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.valid?

    if @message.errors.messages[:from]
      redirect_to root_path, alert: "Your email address doesn't seem to be valid."
    else
      begin
        AdminMailer.invite_email(@message.from).deliver
        redirect_to root_path, notice: "You've been added to our list. Thanks!"
      rescue => e
        redirect_to root_path, alert: "There was a problem: #{e.message}"
      end
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:from)
  end
end
