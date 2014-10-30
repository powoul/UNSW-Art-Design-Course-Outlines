class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string  :code
      t.string  :name
      t.integer :semester_id
      t.integer :units_of_credit
      t.string  :teaching_times_and_locations
      t.string  :online_course_support
      t.string  :parallel_teaching     
      t.text    :summary
      t.text    :course_aims
      t.text    :teaching_philosophy
      t.text    :assessment
      t.text    :resources
      t.integer :semester_id
      t.integer :program_id

      t.timestamps
    end
  end
end
