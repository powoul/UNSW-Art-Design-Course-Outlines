class CreateAssessmentDates < ActiveRecord::Migration
  def change
    create_table :assessment_dates do |t|
      t.date :due
      t.string :description
      t.references :assessment_task
      t.integer :order_number

      t.timestamps
    end
    add_index :assessment_dates, :assessment_task_id
  end
end
