class AddOrderNumberToTaskOutcomes < ActiveRecord::Migration
  def change
    add_column :task_outcomes, :order_number, :int
  end
end
