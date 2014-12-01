class AddOrderNumberToAssessmentTasks < ActiveRecord::Migration
  def change
    add_column :assessment_tasks, :order_number, :int
  end
end
