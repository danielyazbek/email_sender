class AddSendAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :send_attempts do |t|
      t.belongs_to :email, index: true
      t.integer :provider
      t.integer :attempt
      t.timestamps
    end
  end
end
