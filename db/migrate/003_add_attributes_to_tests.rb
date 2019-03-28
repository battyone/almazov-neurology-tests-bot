class AddAttributesToTests < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :just_started, :boolean, default: true, null: false
    add_column :tests, :answered, :boolean, default: false, null: false
    add_column :tests, :questions_qty_wants, :integer, default: 1000
    add_column :tests, :total_qty, :integer
  end
end
