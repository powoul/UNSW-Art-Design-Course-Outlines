class Parameter < ActiveRecord::Base
  attr_accessible :name, :body

  validates_presence_of :name, :body
end
