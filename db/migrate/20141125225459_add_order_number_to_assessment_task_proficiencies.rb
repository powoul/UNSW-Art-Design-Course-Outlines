class AddOrderNumberToAssessmentTaskProficiencies < ActiveRecord::Migration
  def change
    add_column :assessment_task_proficiencies, :order_number, :int
  end
end
