class Discussion < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	belongs_to :user
	belongs_to :forum
	
	validates :title, presence: true
end
