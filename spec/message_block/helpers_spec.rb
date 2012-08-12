require "spec_helper"

describe MessageBlock::Helpers do
  include ActionView::Helpers::TagHelper
  include MessageBlock::Helpers
  
  before do
    @post = Post.new
    @user = User.new
    stub!(:assigns).and_return(:user => @user, :post => @post)
  end
  
  it "should accept valid options" do
    lambda {
      message_block :on => :post, 
        :model_error_type => "fail",
        :flash_types => %w(error warn),
        :html => {:style => 'height: 10em'},
        :id => "block",
        :class => "messages"
    }.should_not raise_error
  end
  
  it "should show nothing with no errors" do
    message_block.should == ''
  end
  
  it "should automatically find post errors with posts controller" do
    @controller = posts_controller
    output = message_block
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li></ul></div>)
  end
  
  it "should give no error for post" do
    output = message_block(:on => :post)
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li></ul></div>)
  end
  
  it "should give error for user" do
    output = message_block(:on => :user)
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li></ul></div>)
  end

  it "should give error for both user and post when using :all" do
    output = message_block(:on => :all)
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li><li>name can't be blank</li></ul></div>)
  end
  
  it "should give errors for both post and user" do
    output = message_block(:on => [:post, :user])
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li><li>name can't be blank</li></ul></div>)
  end
  
  it "should give errors for both post and user in the correct order" do
    output = message_block(:on => [:user, :post])
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li><li>name can't be blank</li></ul></div>)
  end
  
  it "should give error for user given direct instance variable" do
    output = message_block(:on => @user)
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li></ul></div>)
  end
  
  it "should respect model error type" do
    output = message_block(:on => :user, :model_error_type => "fail")
    output.should == %(<div class="message_block" id="message_block"><ul class="fail"><li>name can't be blank</li></ul></div>)
  end
  
  it "should be able to specify id for containing div" do
    output = message_block(:id => "messages")
    output.should == %(<div class="message_block" id="messages"></div>)
  end
  
  it "should be able to specify class for containing div" do
    output = message_block(:class => "messages")
    output.should == %(<div class="messages" id="message_block"></div>)
  end
  
  it "should be able to specify html options for containing div" do
    output = message_block(:html => {:id => "block", :class => "messages"})
    output.should == %(<div class="messages" id="block"></div>)
  end
  
  it "should be able to specify container option as false" do
    output = message_block(:on => :post, :container => false)
    output.should == %(<ul class="error"><li>name can't be blank</li></ul>)
  end
  
  it "should be able to specify container option" do
    output = message_block(:on => :post, :container => :fieldset)
    output.should == %(<fieldset class="message_block" id="message_block"><ul class="error"><li>name can't be blank</li></ul></fieldset>)
  end
  
  it "should be able to see flash error string" do
    flash[:error] = "Error A"
    output = message_block
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>Error A</li></ul></div>)
  end
  
  it "should be able to see flash error array" do
    flash[:error] = ["Error A", "Error B"]
    output = message_block
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>Error A</li><li>Error B</li></ul></div>)
  end
  
  it "should be able to see default flash types" do
    default_types = [:notice, :back, :confirm, :error, :info, :warn].sort_by(&:to_s)
    default_types.each do |type|
      flash[type] = type.to_s
    end
    
    expected_contents = default_types.map do |type|
      content_tag(:ul, content_tag(:li, type.to_s), :class => type.to_s)
    end.join
    
    output = message_block
    output.should == %(<div class="message_block" id="message_block">#{expected_contents}</div>)
  end
  
  it "should be able to see flash error alongside model error" do
    flash[:error] = "Error A"
    output = message_block(:on => :post)
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>Error A</li><li>name can't be blank</li></ul></div>)
  end
  
  it "should be safe for html inside flash messages" do
    flash[:error] = ["Error <strong>A</strong>", "Error <strong>B</strong>"]
    output = message_block
    output.should == %(<div class="message_block" id="message_block"><ul class="error"><li>Error <strong>A</strong></li><li>Error <strong>B</strong></li></ul></div>)
  end
  
end
