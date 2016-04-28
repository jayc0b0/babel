class AddPublishedToBooks < ActiveRecord::Migration
  def change
    remove_column :books, :published
    add_column :books, :published, :string
  end
end
