class EmailSerializer < ActiveModel::Serializer
  attributes :id, :state, :from_address, :to_addresses, :cc_addresses, :bcc_addresses, :subject, :body, :created_at, :updated_at

  def state
    object.aasm_state
  end

  def from_address
    object.from.email
  end

  def to_addresses
    object.to.map{|e| e.email}
  end

  def cc_addresses
    object.cc.map{|e| e.email}
  end

  def bcc_addresses
    object.bcc.map{|e| e.email}
  end
end
