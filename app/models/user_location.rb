class UserLocation < ActiveRecord::Base
  belongs_to :user

  def to_s
  	city
  end
end
