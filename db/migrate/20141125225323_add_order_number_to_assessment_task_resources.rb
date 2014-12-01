class AddOrderNumberToAssessmentTaskResources < ActiveRecord::Migration
  def change
    add_column :assessment_task_resources, :order_number, :int
  end
end
