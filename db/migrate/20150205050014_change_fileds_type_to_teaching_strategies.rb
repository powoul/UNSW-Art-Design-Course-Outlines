class ChangeFiledsTypeToTeachingStrategies < ActiveRecord::Migration
  def up
  	change_column :teaching_strategies, :lectures_description, :text
  	change_column :teaching_strategies, :seminars_description, :text
  	change_column :teaching_strategies, :tutorials_description, :text
  	change_column :teaching_strategies, :studio_description, :text
  	change_column :teaching_strategies, :blended_online_description, :text
  end

  def down
  	change_column :teaching_strategies, :lectures_description, :string
  	change_column :teaching_strategies, :seminars_description, :string
  	change_column :teaching_strategies, :tutorials_description, :string
  	change_column :teaching_strategies, :studio_description, :string
  	change_column :teaching_strategies, :blended_online_description, :string
  end
end
