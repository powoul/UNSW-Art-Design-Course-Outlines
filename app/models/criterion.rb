class Criterion < ActiveRecord::Base
  belongs_to :assessment_task
  attr_accessible :credit, :criteria, :distinction, :fail, :high_distinction, :pass
end
