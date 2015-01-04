class AccountMailer < ActionMailer::Base
  default from: "Accomplice <team@goaccomplice.com>"
  default 'X-SMTPAPI' => Proc.new { smtp_api_header }

  add_template_helper CoursesHelper

  def password_reset(identity)
    @token = identity.password_reset_token
    mail(to: identity.email, subject: "Your Password Reset Request")
  end

  def password_reset_facebook(user)
    mail(to: user.email, subject: "Your Password Reset Request")
  end

  def order_confirmation(user, order)
    @user = user.decorate
    @order = order
    mail(to: @user.email, subject: "#{@user.first_name}, You're Now An Accomplice! (Order Confirmation)")
  end


  private

  def smtp_api_header
    # NOTE: if this data becomes longer than 72 characters, need to wrap:
    # http://sendgrid.com/docs/API_Reference/SMTP_API/index.html
    # $js =~ s/(.{1,72})(\s)/$1\n   /g;

    data = {
      "filters" => {
        "bypass_list_management" => {
          "settings" => {
            "enable" => 1
          }
        }
      }
    }.to_json
  end
end
