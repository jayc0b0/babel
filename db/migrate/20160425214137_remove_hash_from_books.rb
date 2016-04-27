class RemoveHashFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :hash
    add_column :books, :shahash, :string
  end
end
