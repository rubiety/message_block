Feature: Message Block
  
  Scenario: Installing Static Files
    Given I have a rails application
    And I run "rake message_block:install --trace"
    Then the file "public/images/message_block" should exist
    And the file "public/stylesheets/message_block.css" should exist
    And the file "public/javascripts/message_block.js" should exist
  
  Scenario: Displaying Model Errors mixed with Flash Messages
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
      class ModelsController < ApplicationController
        def index
          @model = Model.new
          @model.errors.add(:base, "Model-One")
          @model.errors.add(:base, "Model-Two")
          
          flash.now[:error] = "Controller-One"
          flash.now[:confirm] = "Controller-Two"
        end
      end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
      <%= message_block :on => :model %>
    """
    And the rails application is running
    When I go to the models page
    Then I should see "Model-One"
    And I should see "Model-Two"
    And I should see "Controller-One"
    And I should see "Controller-Two"
  