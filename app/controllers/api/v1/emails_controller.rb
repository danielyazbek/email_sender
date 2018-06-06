class Api::V1::EmailsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    emails = Email.includes(:from, :to, :cc, :bcc).all.order(updated_at: :desc)
    json_response(ActiveModelSerializers::SerializableResource.new(emails, {}).to_json)
  end

  def create
    email = Email.new(email_params)
    if email.save
      EmailDeliveryWorker.perform_async(email.id)
      json_response({id: email.id})
    else
      json_response({errors: email.errors.full_messages}, :bad_request)
    end
  end

  private

  def email_params
    params.permit(:subject, :body, from_attributes: [:email], to_attributes: [:email], cc_attributes: [:email], bcc_attributes: [:email])
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
