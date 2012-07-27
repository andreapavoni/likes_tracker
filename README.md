# LikesTracker

A Rails gem to track *likes* between two ```ActiveModel``` compliant models.  A common use case might be that a User likes a Post.

## Installation

Add this line to your application's Gemfile:

```gem 'likes_tracker'```

And then execute:

```$ bundle install```

Or install it yourself as:

```$ gem install likes_tracker```

### Dependencies

* [redis](http://redis.io)
* ruby 1.9+ (it uses some 1.9's syntax)

## Usage

First of all, you need a ```$redis``` in your app, you might achieve this using an initializer:

```
# config/initializers/redis.rb
$redis = Redis.new(host: 'localhost', port: '6379', db: '1')
```

Given you have two models, say User and Post, and you want to track the *likes* a given Post receives by User(s). Include the LikesTracker module and use the methods it offers to setup models as *liker* and *liked*:

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

Now your models will have some methods to manage the likes a model *gives* to another. Following the above example:

```
> user.likes_post? post
 => false

> user.liked_posts
 => []

> post.likes_users_count
 => 0

> user.like_post! post
 => [true, true, 1.0]

> user.likes_post? post
 => true
```

As you can see, the methods' names reflect model names (and they'll be properly namespaced on Redis). This means, that the same models can like
several others, for example User might like another model called Photo or Comment.

How to find Posts liked by a User? There's a method for this, of course ;-)

```
> user.liked_posts
 => [#<Post id: 1, ...>]
```
It returns a *relation*, such as ```ActiveRecord::Relation```. Even if I
haven't tested it yet, this *should* work with other ORMs like Mongoid.

However, this method has an experimental feature: it accepts a block to operate custom queries. I'm still not sure I will expand it to other methods.

```
# a silly example to show how it works
> user.liked_posts {|model, ids| p [model, ids] }
 => [Post(id: integer, ...), ["1"]]

# the query executed by default
> user.liked_posts {|model, ids| model.where(id: ids) }
 => [#<Post id: 1, ...>]
```

Last but not least, here there're the remaining methods and examples:

```
# you should provide a *limit* parameter
> Post.most_liked(5)
 => [#<Post id: 1, ...>]

> post.likes_users_count
 => 1

> user.unlike_post! post
 => [true, true, 0.0]

> user.likes_post? post
 => false

> user.liked_posts
 => []

> post.likes_users_count
 => 0
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Testing

* clone this repo
* run `bundle install`
* run `rspec spec`


## License
Copyright (c) 2012 Andrea Pavoni http://andreapavoni.com
