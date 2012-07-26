class Post < ActiveRecord::Base
  attr_accessible :title

  include LikesTracker
  acts_as_liked_by :users
end
