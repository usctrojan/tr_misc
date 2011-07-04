class Collection < ActiveRecord::Base
  
  validates_uniqueness_of :name
  has_many :ribbons
end