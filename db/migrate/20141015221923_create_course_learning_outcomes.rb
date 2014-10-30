class CreateCourseLearningOutcomes < ActiveRecord::Migration
  def change
    create_table :course_learning_outcomes do |t|
      t.string :name
      t.references :course

      t.timestamps
    end
    add_index :course_learning_outcomes, :course_id
  end
end
