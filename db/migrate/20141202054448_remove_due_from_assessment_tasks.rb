class RemoveDueFromAssessmentTasks < ActiveRecord::Migration
  def up
  	remove_column :assessment_tasks, :due
  end

  def down
  	add_column :assessment_tasks, :due, :date
  end
end
