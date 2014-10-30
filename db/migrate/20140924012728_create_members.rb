class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :associate
      t.belongs_to :user
      t.string :associate_type
      t.string :role
      t.string :consultation_times
      t.timestamps
    end
  end
end
