class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title, :null => false
      t.string :description
      t.boolean :completed, :default => false
      t.references :todo_list
    end
  end
end
