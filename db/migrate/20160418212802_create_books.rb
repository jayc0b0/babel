class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :published
      t.integer :isbn
      t.string :cover

      t.timestamps null: false
    end
  end
end
