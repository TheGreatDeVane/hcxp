class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :saves
  has_many :saved_events, through: :saves, source: :event
  has_many :events
  has_many :services
end
