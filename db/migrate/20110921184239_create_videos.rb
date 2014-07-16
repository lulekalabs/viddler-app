class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :tags
      t.string :url
      t.string :thumbnail_url
      t.integer :user_id
      t.integer :session_id
      t.string :video_id
      t.string :type
      t.timestamps
    end
    add_index :videos, :user_id
    add_index :videos, :session_id
    add_index :videos, :video_id
    add_index :videos, :type
  end
end
