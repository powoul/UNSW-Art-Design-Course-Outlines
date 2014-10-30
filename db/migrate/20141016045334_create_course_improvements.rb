class CreateCourseImprovements < ActiveRecord::Migration
  def change
    create_table :course_improvements do |t|
      t.string :description
      t.references :course

      t.timestamps
    end
    add_index :course_improvements, :course_id
  end
end