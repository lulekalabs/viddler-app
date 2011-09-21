class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :tags
      t.string :url
      t.string :thumbnail_url
      t.string :slug
      t.integer :user_id
      t.integer :session_id
      t.string :video_id
      t.string :source
      t.timestamps
    end
    add_index :videos, :slug
    add_index :videos, :user_id
    add_index :videos, :session_id
    add_index :videos, :video_id
  end
end
