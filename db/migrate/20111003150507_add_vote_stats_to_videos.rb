class AddVoteStatsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :votes_count, :integer, :null => false, :default => 0
    add_column :videos, :votes_sum, :integer, :null => false, :default => 0
  end
end
