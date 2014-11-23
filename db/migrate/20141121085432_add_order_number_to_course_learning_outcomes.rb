class AddOrderNumberToCourseLearningOutcomes < ActiveRecord::Migration
  def change
    add_column :course_learning_outcomes, :order_number, :int
  end
end
