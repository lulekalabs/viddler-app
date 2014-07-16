class AddPublishedAtToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :published_at, :datetime
    add_index :videos, :published_at
  end
end
