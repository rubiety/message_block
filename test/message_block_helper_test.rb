require 'rubygems'
require 'test/unit'
require 'action_pack'
require 'action_view'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

class MessageBlockHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include Rubiety::MessageBlock::Helpers
  
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
  
  
  def setup
    setup_post
    setup_user
  end
  
  
  ### Generic Invocation
  def test_doesnt_accept_invalid_options
    assert_raise(ArgumentError) { message_block :invalid => 'value' }
  end
  
  def test_accepts_valid_options
    assert_nothing_raised do 
      message_block :on => :post, 
        :model_error_type => "fail",
        :flash_types => %w(error warn),
        :html => {:style => 'height: 10em'},
        :id => "block",
        :class => "messages"
    end
  end
  
  
  ### Grabbing model errors functionality
  def test_without_errors_should_show_nothing
    expected = %(<div id="message_block"></div>)
    assert_equal expected, message_block
  end
  
  def test_automatically_find_post_errors_with_posts_controller
    @controller = posts_controller
    expected = %(<div id="message_block"><ul class="error"><li>Author name can't be empty</li></ul></div>)
    assert_equal expected, message_block
  end
  
  def test_gives_error_for_post
    expected = %(<div id="message_block"><ul class="error"><li>Author name can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => :post)
  end
  
  def test_gives_error_for_user
    expected = %(<div id="message_block"><ul class="error"><li>User email can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => :user)
  end
  
  def test_gives_both_errors_for_post_and_user
    expected = %(<div id="message_block"><ul class="error"><li>Author name can't be empty</li><li>User email can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => [:post, :user])
  end
  
  def test_gives_both_errors_for_post_and_user_in_correct_order
    expected = %(<div id="message_block"><ul class="error"><li>User email can't be empty</li><li>Author name can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => [:user, :post])
  end
  
  def test_gives_error_for_user_given_direct_instance_variable
    expected = %(<div id="message_block"><ul class="error"><li>User email can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => @user)
  end
  
  def test_respects_model_error_type
    expected = %(<div id="message_block"><ul class="fail"><li>User email can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => :user, :model_error_type => "fail")
  end
  
  
  ### Extending HTML options for containing div functionality
  def test_can_specify_id_for_containing_div
    expected = %(<div id="messages"></div>)
    assert_equal expected, message_block(:id => "messages")
  end
  
  def test_can_specify_class_for_containing_div
    expected = %(<div class="messages" id="message_block"></div>)
    assert_equal expected, message_block(:class => "messages")
  end
  
  def test_can_specify_html_options_for_containing_div
    expected = %(<div class="messages" id="block"></div>)
    assert_equal expected, message_block(:html => {:id => "block", :class => "messages"})
  end
  
  def test_can_specify_container_option_as_false
    expected = %(<ul class="error"><li>Author name can't be empty</li></ul>)
    assert_equal expected, message_block(:on => :post, :container => false)
  end
  
  def test_can_specify_container_option
    expected = %(<fieldset id="message_block"><ul class="error"><li>Author name can't be empty</li></ul></fieldset>)
    assert_equal expected, message_block(:on => :post, :container => :fieldset)
  end
  
  
  ### Flash messages functionality
  def test_sees_flash_error_string
    flash[:error] = "Error A"
    expected = %(<div id="message_block"><ul class="error"><li>Error A</li></ul></div>)
    assert_equal expected, message_block
  end
  
  def test_sees_flash_error_array
    flash[:error] = ["Error A", "Error B"]
    expected = %(<div id="message_block"><ul class="error"><li>Error A</li><li>Error B</li></ul></div>)
    assert_equal expected, message_block
  end
  
  def test_sees_default_flash_types
    default_types = [:back, :confirm, :error, :info, :warn]
    default_types.each do |type|
      flash[type] = type.to_s
    end
    
    expected_contents = default_types.map do |type|
      content_tag(:ul, content_tag(:li, type.to_s), :class => type.to_s)
    end.join
    
    expected = %(<div id="message_block">#{expected_contents}</div>)
    assert_equal expected, message_block
  end
  
  def test_sees_flash_error_alongside_model_error
    flash[:error] = "Error A"
    expected = %(<div id="message_block"><ul class="error"><li>Error A</li><li>Author name can't be empty</li></ul></div>)
    assert_equal expected, message_block(:on => :post)
  end
  
end
