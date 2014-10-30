class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zid, :null => false
      t.string :fullname, :null => false, :defautl => ''
      t.string :email, :default =>''
      t.string :phone_number, :default => ''
      t.string :mobile_number, :default => ''
      t.string :room, :default => ''
      t.string :role, :default => ''

      t.timestamps
    end
  end
end
