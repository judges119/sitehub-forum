class Discussion < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	belongs_to :user
	belongs_to :forum
	
	validates :title, presence: true
	validates :user_id, presence: true
	validates :forum_id, presence: true
end
