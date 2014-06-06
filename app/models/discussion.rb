class Discussion < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	belongs_to :user
end
