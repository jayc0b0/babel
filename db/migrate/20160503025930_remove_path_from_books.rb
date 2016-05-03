class RemovePathFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :path
  end
end
