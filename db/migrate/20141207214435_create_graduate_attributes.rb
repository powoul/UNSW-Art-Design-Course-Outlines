class CreateGraduateAttributes < ActiveRecord::Migration
  def change
    create_table :graduate_attributes do |t|
      t.string :name

      t.timestamps
    end
  end
end
