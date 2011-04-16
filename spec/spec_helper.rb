require "rubygems"
require "message_block"
require "active_support"
require "active_model"
require "action_pack"
require "action_view"

require File.dirname(__FILE__) + '/../init'

class Post
  extend ActiveModel::Naming

  attr_accessor :name
  attr_reader :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
    @errors.add(:name, "can't be blank")
  end
  
  def read_attribute_for_validation(attr)
    send(attr)
  end
  
  def self.human_attribute_name(attr, options = {})
    attr
  end
  
  def self.lookup_ancestors
    [self]
  end
end

class User
  extend ActiveModel::Naming

  attr_accessor :name
  attr_reader :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
    @errors.add(:name, "can't be blank")
  end
  
  def read_attribute_for_validation(attr)
    send(attr)
  end
  
  def self.human_attribute_name(attr, options = {})
    attr
  end
  
  def self.lookup_ancestors
    [self]
  end
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
