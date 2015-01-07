class CreateAssessmentAttributes < ActiveRecord::Migration
  def change
    create_table :assessment_attributes do |t|
      t.references :course
      t.references :graduate_attribute

      t.timestamps
    end
    add_index :assessment_attributes, :course_id
    add_index :assessment_attributes, :graduate_attribute_id
  end
end
