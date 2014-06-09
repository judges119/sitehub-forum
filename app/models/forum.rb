class Forum < ActiveRecord::Base
  has_many :discussions, :dependent => :destroy
  
  validates :name, presence: true
end
