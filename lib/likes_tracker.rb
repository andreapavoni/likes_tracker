require "likes_tracker/version"

module LikesTracker
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_liker_for(model)
      model_name = model.to_s.singularize.downcase
      model_class = model.to_s.singularize.capitalize.constantize

      model_table = model_name.pluralize
      self_table = self.name.downcase.pluralize

      liker_key = "#{model_table}:likes"
      liked_key = "#{self_table}:likers"

      # like <object>
      define_method "like_#{model_name}!" do |obj|
        $redis.multi do
          $redis.sadd(self.redis_key(liker_key), obj.id)
          $redis.sadd(obj.redis_key(liked_key), self.id)
          $redis.zincrby("#{model_table}:like_scores", 1, obj.id)
        end unless self.send("likes_#{model_name}?", obj)
      end

      # remove like from <object>
      define_method "unlike_#{model_name}!" do |obj|
        $redis.multi do
          $redis.srem(self.redis_key(liker_key), obj.id)
          $redis.srem(obj.redis_key(liked_key), self.id)
          $redis.zincrby("#{model_table}:like_scores", -1, obj.id)
        end if self.send("likes_#{model_name}?", obj)
      end

      # checks if <object> is liked or not
      define_method "likes_#{model_name}?" do |obj|
        $redis.sismember(self.redis_key(liker_key), obj.id)
      end

      # find liked <object>s
      define_method "liked_#{model_name.pluralize}" do |&block|
        liked_ids = $redis.smembers self.redis_key(liker_key)

        if block
          blk = ->(klass, params) { block.call(klass, params) }
          blk.call(model_class, liked_ids)
        else
          model_class.where(id: liked_ids)
        end
      end

    end # acts_as_liker_for

    def acts_as_liked_by(model)
      model_name = model.to_s.singularize.downcase
      model_class = model.to_s.singularize.capitalize.constantize

      model_table = model_name.pluralize

      liker_key = "#{model_table}:likers"

      # count received likes
      define_method "likes_#{model_name.pluralize}_count" do
        $redis.scard self.redis_key(liker_key)
      end

      # find the first <limit> <object>s with more likes
      define_singleton_method :most_liked do |limit=5|
        limit -= 1 if (limit > 0)
        most_liked_key = "#{self.name.downcase.pluralize}:like_scores"
        most_liked_ids = $redis.zrevrange(most_liked_key, 0, limit)
        self.where(id: most_liked_ids)
      end

    end # acts_as_liked_by

  end

  # generate a redis key, based on class name and an optional string
  def redis_key(key)
    "#{self.class.name.downcase.pluralize}:#{self.id}:#{key}"
  end

end
