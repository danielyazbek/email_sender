class AddEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :from_address
      t.text :to_addresses
      t.text :cc_addresses
      t.text :bcc_addresses
      t.text :subject
      t.text :body
      t.string :aasm_state

      t.timestamps
    end

  end
end
