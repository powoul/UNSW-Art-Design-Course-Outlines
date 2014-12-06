class ChangeNumberTypeToPrograms < ActiveRecord::Migration
  def up
  	change_column :programs, :number, :string, :default =>""
  end

  def down
  	change_column :programs, :number, :integer
  end
end
