class EmailSerializer < ActiveModel::Serializer
  attributes :id, :state, :from_address, :to_addresses, :cc_addresses, :bcc_addresses, :subject, :body, :created_at, :updated_at

  def state
    object.aasm_state
  end
end
