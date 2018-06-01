module SendgridService

  def self.send_email(email, send_attempt)
    unless send_attempt.sendgrid?
      raise ArgumentError, 'send attempt not intended for this service'
    end

    response = connection.post do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{ENV['SENDGRID_API_KEY']}"
      request.body = build_request_body(email).to_json
    end

    unless response.success?
      return false, "Mail not be delivered via Sendgrid. Response status: #{response.status}"
    end

    id = response.headers["x-message-id"]
    send_attempt.update_attributes(successful: true, provider_id: id)
    return true, ''
  end

  private

  def self.connection
    Faraday.new(url: ENV['SENDGRID_URL']) do |f|
      # f.response :logger
      f.adapter Faraday.default_adapter
    end
  end

  def self.build_request_body(email)
    {}.tap do |req|
      req[:personalizations] = [{}.tap do |p|
        p[:to] = email.to_addresses.map{|to_address| {email: to_address} }
        p[:cc] = email.cc_addresses.map{|cc_address| {email: cc_address} } if email.cc_addresses.any?
        p[:bcc] = email.bcc_addresses.map{|bcc_address| {email: bcc_address} } if email.bcc_addresses.any?
        p[:subject] = email.subject
      end]
      req[:from] = {email: email.from_address}
      req[:content] = [{
        type: 'text/plain',
        value: email.body
      }]
    end
  end
end
