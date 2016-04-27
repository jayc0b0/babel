class AddHashToBooks < ActiveRecord::Migration
  def change
    add_column :books, :shahash, :string
    remove_column :books, :hash
  end
end
