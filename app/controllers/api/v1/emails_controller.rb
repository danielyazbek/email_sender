class Api::V1::EmailsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    emails = Email.all.order(updated_at: :desc)
    json_response(ActiveModelSerializers::SerializableResource.new(emails, {}).to_json)
  end

  def create
    email = Email.new(email_params)
    if email.save
      EmailDeliveryWorker.perform_async(email.id)
      json_response({id: email.id})
    else
      json_response({errors: email.errors}, :bad_request)
    end
  end

  private

  def email_params
    params.permit(:from_address, :subject, :body, {to_addresses: []}, {cc_addresses: []}, {bcc_addresses: []})
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
