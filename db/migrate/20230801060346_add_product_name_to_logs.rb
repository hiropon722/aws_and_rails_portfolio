class AddProductNameToLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :logs, :product_name, :string
  end
end
