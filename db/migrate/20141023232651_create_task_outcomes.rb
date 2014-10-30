class CreateTaskOutcomes < ActiveRecord::Migration
  def change
    create_table :task_outcomes do |t|
    	t.integer :assessment_task_id
  		t.integer :course_learning_outcome_id

      t.timestamps
    end
  end
end
