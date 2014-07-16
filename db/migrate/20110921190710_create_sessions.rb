class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_id
      t.string :ip
      t.string :user_agent
      t.integer :user_id
      t.timestamps
    end
    add_index :sessions, :session_id
    add_index :sessions, :user_id
  end
end
