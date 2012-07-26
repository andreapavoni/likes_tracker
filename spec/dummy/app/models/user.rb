class User < ActiveRecord::Base
  attr_accessible :username

  include LikesTracker
  acts_as_liker_for :posts

end
