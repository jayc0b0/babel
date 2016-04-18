class AddBookFilename < ActiveRecord::Migration
  def change
    add_column :books, :filename, :string
    add_column :books, :path, :string
  end
end
