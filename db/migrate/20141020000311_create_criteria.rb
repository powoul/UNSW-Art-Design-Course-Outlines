class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.string :criteria
      t.string :fail
      t.string :pass
      t.string :credit
      t.string :distinction
      t.string :high_distinction
      t.references :assessment_task

      t.timestamps
    end
    add_index :criteria, :assessment_task_id
  end
end
