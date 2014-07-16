class RemoveTypeFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :type
  end

  def down
    add_column :videos, :type, :string
  end
end
