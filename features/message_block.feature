Feature: Message Block
  
  Scenario: Installing Static Files
    Given I have a rails application
    And I run "rake message_block:install --trace"
    Then the file "public/images/message_block" should exist
    And the file "public/stylesheets/message_block.css" should exist
    And the file "public/javascripts/message_block.js" should exist
  
  Scenario: Displaying Flash Messages
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
      class ModelsController < ApplicationController
        def index
          flash.now[:error] = ["Error-One", "Error-Two"]
          flash.now[:confirm] = "Confirm-One"
        end
      end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
      <%= message_block %>
    """
    And the rails application is prepped and running
    When I go to the models page
    Then I should see "Error-One"
    And I should see "Error-Two"
    And I should see "Confirm-One"
  
  Scenario: Displaying Model Errors
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
      class ModelsController < ApplicationController
        def index
          @model = Model.new
          @model.errors.add_to_base("Error-One")
          @model.errors.add_to_base("Error-Two")
        end
      end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
      <%= message_block :on => :model %>
    """
    And the rails application is prepped and running
    When I go to the models page
    Then I should see "Error-One"
    And I should see "Error-Two"
  
  Scenario: Displaying Model Errors for Multiple Objects
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
      class ModelsController < ApplicationController
        def index
          @model1 = Model.new
          @model1.errors.add_to_base("Error-One")
          @model2 = Model.new
          @model2.errors.add_to_base("Error-Two")
        end
      end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
      <%= message_block :on => [:model1, :model2] %>
    """
    And the rails application is prepped and running
    When I go to the models page
    Then show me the page
    Then I should see "Error-One"
    And I should see "Error-Two"
  
  Scenario: Displaying Model Errors mixed with Flash Messages
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
      class ModelsController < ApplicationController
        def index
          @model = Model.new
          @model.errors.add_to_base("Model-One")
          @model.errors.add_to_base("Model-Two")
          
          flash.now[:error] = "Controller-One"
          flash.now[:confirm] = "Controller-Two"
        end
      end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
      <%= message_block :on => :model %>
    """
    And the rails application is prepped and running
    When I go to the models page
    Then I should see "Model-One"
    And I should see "Model-Two"
    And I should see "Controller-One"
    And I should see "Controller-Two"
  