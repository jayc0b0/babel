class AddCategoryToBooks < ActiveRecord::Migration
  def change
    add_column :books, :category, :string
    remove_column :books, :type
  end
end
