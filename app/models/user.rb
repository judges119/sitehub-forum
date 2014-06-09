class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :posts
  has_many :edits, :class_name => 'Post', :foreign_key => :edited_by_id
  has_many :discussions
  
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :username, uniqueness: true, presence: true, format: { with: /\A[a-zA-Z0-9_].+[a-zA-Z0-9_]\z/, message: "Must start and end with an alphanumeric character or underscore" }
end
