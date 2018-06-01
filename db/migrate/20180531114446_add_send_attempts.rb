class AddSendAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :send_attempts do |t|
      t.belongs_to :email, index: true
      t.integer :provider
      t.integer :attempt
      t.string :provider_id
      t.string :provider_message
      t.boolean :successful, default: false
      t.timestamps
    end
  end
end
