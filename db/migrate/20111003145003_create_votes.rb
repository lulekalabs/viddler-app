class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer  "video_id", :null => false
      t.integer  "session_id", :null => false
      t.integer  "points", :default => 0, :null => false
      t.timestamps
    end
    add_index :votes, :video_id
    add_index :votes, :session_id
  end
end
