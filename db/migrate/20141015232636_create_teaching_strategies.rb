class CreateTeachingStrategies < ActiveRecord::Migration
  def change
    create_table :teaching_strategies do |t|
      t.boolean :lectures, :default => false
      t.string :lectures_description
      t.boolean :seminars, :default => false
      t.string :seminars_description
      t.boolean :tutorials, :default => false
      t.string :tutorials_description
      t.boolean :studio, :default => false
      t.string :studio_description
      t.boolean :blended_online, :default => false
      t.string :blended_online_description
      t.string :teaching_philosophy
      t.references :course

      t.timestamps
    end
    add_index :teaching_strategies, :course_id
  end
end
