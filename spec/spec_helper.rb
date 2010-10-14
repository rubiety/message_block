require "rubygems"
require "message_block"
require "active_support"
require "action_pack"
require "action_view"

require File.dirname(__FILE__) + '/../init'

# Borrowed model stubs from Rails active_record_helper_test.rb
# TODO: Re-implement using mocha
Post = Struct.new("Post", :title, :author_name)
User = Struct.new("User", :email)

def setup_post
  @post = Post.new
  def @post.errors
    Class.new do
      def on(field)
        case field.to_s
        when "author_name"
          "can't be empty"
        when "body"
          true
        else
          false
        end
      end
      def empty?() false end
      def count() 1 end
      def full_messages() [ "Author name can't be empty" ] end
    end.new
  end
  
  @post.title       = "Hello World"
  @post.author_name = ""
end

def setup_user
  @user = User.new
  def @user.errors
    Class.new {
      def on(field) field == "email" end
      def empty?() false end
      def count() 1 end
      def full_messages() [ "User email can't be empty" ] end
    }.new
  end
  
  @user.email = ""
end

def controller
  @controller ||= Class.new {
    def controller_name
      "widgets_controller"
    end
  }.new
end

def posts_controller
  Class.new {
    def controller_name
      "posts_controller"
    end
  }.new
end

def flash
  @flash ||= {}
end