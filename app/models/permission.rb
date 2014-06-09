class Permission < ActiveRecord::Base
  belongs_to :groups
  belongs_to :forums
end
