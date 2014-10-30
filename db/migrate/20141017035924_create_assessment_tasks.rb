class CreateAssessmentTasks < ActiveRecord::Migration
  def change
    create_table :assessment_tasks do |t|
      t.string :title
      t.date :due
      t.integer :weighting
      t.text :synopsis
      t.text :feedback
      t.references :course

      t.timestamps
    end
    add_index :assessment_tasks, :course_id
  end
end
