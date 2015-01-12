class CreateAssessmentAttributes < ActiveRecord::Migration
  def change
    create_table :assessment_attributes do |t|
      t.references :assessment_task, :index => true
      t.references :graduate_attribute, :index => true

    end
  end
end
