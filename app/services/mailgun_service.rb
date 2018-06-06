module MailgunService

  def self.send_email(email, send_attempt)
    unless send_attempt.mailgun?
      raise ArgumentError, 'send attempt not intended for this service'
    end

    response = connection.post do |request|
      request.params['from'] = email.from.email
      request.params['to'] = email.to.map{|e| e.email}
      request.params['cc'] = email.cc.map{|e| e.email}
      request.params['bcc'] = email.bcc.map{|e| e.email}
      request.params['subject'] = email.subject
      request.params['text'] = email.body
      request.options.params_encoder = Faraday::FlatParamsEncoder
    end

    unless response.success?
      return false, "Mail not delivered via Mailgun. Response status: #{response.status}"
    end

    id = response.body["id"]
    message = response.body["message"]
    send_attempt.update_attributes(successful: true, provider_id: id, provider_message: message)
    return true, ''
  end

  private

  def self.connection
    Faraday.new(url: ENV['MAILGUN_URL']) do |f|
      f.request :url_encoded
      f.basic_auth 'api', ENV['MAILGUN_API_KEY']
      f.response :json, :content_type => 'application/json'
      f.adapter Faraday.default_adapter
    end
  end
end
