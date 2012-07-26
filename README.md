# LikesTracker

A Rails gem to tracks *likes* between 2 ```ActiveModel``` compliant models (eg: User likes Post).

## Installation

Add this line to your application's Gemfile:

    gem 'likes_tracker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install likes_tracker

## Usage

Given you have two models, say User and Post, and you want to track
the *likes* a given Post receives by User(s). Include the LikesTracker
module and use the methods it offers to setup models as *liker* and
*liked*:

```
# app/models/post.rb
class Post < ActiveRecord::Base
  include LikesTracker
  acts_as_liked_by :users

  # rest of the code
end

# app/models/user.rb
class User < ActiveRecord::Base
  include LikesTracker
  acts_as_liker_for :posts

  # rest of the code
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
