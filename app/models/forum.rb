class Forum < ActiveRecord::Base
  has_many :discussions, :dependent => :destroy
  has_many :permissions
  has_many :groups, through: :permissions
end
