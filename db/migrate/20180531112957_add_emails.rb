class AddEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :subject
      t.text :body
      t.string :aasm_state

      t.timestamps
    end

  end
end
