class AddLateSubmissionAllowedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :late_submission_allowed, :boolean
  end
end
