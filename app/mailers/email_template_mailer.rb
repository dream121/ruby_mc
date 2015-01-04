class EmailTemplateMailer < ActionMailer::Base
  default from: "Accomplice <team@goaccomplice.com>"

  def generate(user, course, kind)
    @user = user.decorate
    @course = course.decorate
    find_template kind
    send_mail
  end

  private

  class EmailTemplateMailer::TemplateNotFound < StandardError; end

  def find_template(kind)
    begin
      @email = @course.email_templates.find_by!(kind: kind)
    rescue ActiveRecord::RecordNotFound
      raise EmailTemplateMailer::TemplateNotFound.new(%Q(No "#{kind}" template found for "#{@course.title}"))
    end
  end

  def send_mail
    subject = ERB.new(@email.subject).result(binding)
    msg = ERB.new(@email.body).result(binding)
    mail(to: @user.email, from: @email.from, subject: subject) do |format|
      format.html { render inline: msg }
    end
  end

end
