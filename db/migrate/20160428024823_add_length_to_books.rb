class AddLengthToBooks < ActiveRecord::Migration
  def change
    add_column :books, :length, :integer
  end
end
