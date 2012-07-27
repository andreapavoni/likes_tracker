require 'spec_helper'

describe LikesTracker do
  let(:user) { FactoryGirl.create :user }
  let(:post) { FactoryGirl.create :post }

  before(:each) do
    $redis.flushdb
  end

  context ".acts_as_liker_for" do
    it "includes LikesTracker module" do
      user.class.ancestors.should include(LikesTracker)
    end

    describe "#like_post!" do
      it "adds like to a post" do
        user.like_post! post
        user.liked_posts.should == [post]
      end

      it "doesn't add like to an already liked post" do
        user.like_post! post
        user.like_post! post
        user.liked_posts.should == [post]
      end
    end # like_post!

    describe "#unlike_post!" do
      before(:each) do
        user.like_post! post
      end

      it "removes like from a post" do
        user.unlike_post! post

        user.liked_posts.should_not == [post]
      end

      it "doesn't remove like from a non-liked post" do
        user.unlike_post! post
        user.liked_posts.should == []

        # repeat above ops, check it does nothing
        user.unlike_post! post
        user.liked_posts.should == []
      end

    end # unlike_post!

    describe "#likes_post?" do
      it "is true if a post is liked by user" do
        user.like_post! post
        user.likes_post?(post).should be_true
      end

      it "is false if a post isn't liked by user" do
        user.likes_post?(post).should_not be_true
      end

    end # likes_post?

    describe "#liked_posts" do
      it "returns an ActiveRecord::Relation" do
        user.liked_posts.should be_a(ActiveRecord::Relation)
      end

      it "return posts liked by user" do
        user.like_post! post
        user.liked_posts.should include(post)
      end

    end # liked_posts

  end # .acts_as_liker_for

  context ".acts_as_liked_by" do
    it "includes LikesTracker module" do
      post.class.ancestors.should include(LikesTracker)
    end

    describe "#likes_users_count" do
      it "returns the number of users who liked this post" do
        post.likes_users_count.should == 0

        user.like_post! post
        post.likes_users_count.should == 1
      end

    end # likes_users_count

    describe ".most_liked" do
      let(:user2) { FactoryGirl.create :user }
      let(:post2) { FactoryGirl.create :post }

      before(:each) do
        user.like_post! post

        user.like_post! post2
        user2.like_post! post

        post.likes_users_count.should == 2
        post2.likes_users_count.should == 1
      end

      it "returns an ActiveRecord::Relation" do
        Post.most_liked(5).should be_a(ActiveRecord::Relation)
      end

      it "return most liked posts" do
        Post.most_liked(5).should == [post, post2]
      end

      it "defaults limit to 5" do
        Post.most_liked.should == [post, post2]
      end

    end # .most_liked

  end # .acts_as_liked_by

end
