class AddOrderNumberToCriteria < ActiveRecord::Migration
  def change
    add_column :criteria, :order_number, :int
  end
end
