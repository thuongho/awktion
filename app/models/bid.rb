class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction

  # make sure the number entered is a number
  validates_numericality_of :value
end
