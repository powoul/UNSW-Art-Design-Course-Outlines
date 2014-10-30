class CreateAssessmentTaskProficiencies < ActiveRecord::Migration
  def change
    create_table :assessment_task_proficiencies do |t|
      t.string :proficiency
      t.references :assessment_task

      t.timestamps
    end
    add_index :assessment_task_proficiencies, :assessment_task_id
  end
end
