class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :number
      t.string :description

      t.timestamps
    end
  end
end
