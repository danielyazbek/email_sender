class AddEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :to_addresses
      t.text :cc_addresses
      t.text :bcc_addresses
      t.text :subject
      t.text :body

      t.timestamps
    end

  end
end
