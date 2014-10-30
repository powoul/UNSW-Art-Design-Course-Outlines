class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.string :year
      t.date :start
      t.date :end
      t.date :non_teaching_week
      t.date :mid_semester_break

      t.timestamps
    end
  end
end
