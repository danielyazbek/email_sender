class AddEmailAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :email_addresses do |t|
      t.string :email
      t.references :from_email
      t.references :to_email
      t.references :cc_email
      t.references :bcc_email
      t.timestamps
    end
  end
end
