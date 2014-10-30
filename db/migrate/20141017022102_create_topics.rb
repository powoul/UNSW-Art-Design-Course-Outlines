class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer    :week
      t.date       :date
      t.string     :topic_name
      t.string     :tasks_due
      t.string     :bgcolor
      t.references :course

      t.timestamps
    end
    add_index :topics, :course_id
  end
end
