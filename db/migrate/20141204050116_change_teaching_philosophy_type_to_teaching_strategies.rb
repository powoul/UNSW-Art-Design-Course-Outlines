class ChangeTeachingPhilosophyTypeToTeachingStrategies < ActiveRecord::Migration
  def up
  	change_column :teaching_strategies, :teaching_philosophy, :text
  	remove_column :courses, :teaching_philosophy
  end

  def down
  	add_column :courses, :teaching_philosophy, :text
  	change_column :teaching_strategies, :teaching_philosophy, :string
  end
end
