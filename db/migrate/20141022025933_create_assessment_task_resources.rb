class CreateAssessmentTaskResources < ActiveRecord::Migration
  def change
    create_table :assessment_task_resources do |t|
      t.string :resource
      t.references :assessment_task

      t.timestamps
    end
    add_index :assessment_task_resources, :assessment_task_id
  end
end
