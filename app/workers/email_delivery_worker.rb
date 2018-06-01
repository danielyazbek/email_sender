class EmailDeliveryWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg, ex|
    email_id = msg['args'].first
    email = Email.find(email_id)
    email.failed!
  end

  def perform(email_id)
    email = Email.find(email_id)
    send_attempt = email.send_attempts.create

    if send_attempt.mailgun?
      service = MailgunService
    elsif send_attempt.sendgrid?
      service = SendgridService
    else
      raise ArgumentError, "Unknown email provider '#{send_attempt.provider}'"
    end

    success, error_message = service.send_email(email, send_attempt)
    if success
      email.delivered!
    else
      raise StandardError, error_message
    end
  end
end
