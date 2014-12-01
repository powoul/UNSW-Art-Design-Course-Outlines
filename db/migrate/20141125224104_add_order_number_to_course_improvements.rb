class AddOrderNumberToCourseImprovements < ActiveRecord::Migration
  def change
    add_column :course_improvements, :order_number, :int
  end
end
