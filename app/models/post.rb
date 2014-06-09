class Post < ActiveRecord::Base
	belongs_to :topic
	belongs_to :user
	belongs_to :editor, :class_name => 'User', :foreign_key => :edited_by_id
	
	validates :content, presence: true
end
