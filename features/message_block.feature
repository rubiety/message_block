Feature: Message Block
  Scenario: Installing Static Files
    Given I have a rails application
    And I run "rake message_block:install --trace"
    Then the file "public/images/message_block" should exist
    And the file "public/stylesheets/message_block.css" should exist
    And the file "public/javascripts/message_block.js" should exist
  
  Scenario: Displaying Model Errors mixed with Flash Messages
    Given I have a rails application
    And I run "rails g scaffold model name:string"
    And I setup the database
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
    And I start the rails application
    When I go to the models page
    Then I should see "Model-One"
    And I should see "Model-Two"
    And I should see "Controller-One"
    And I should see "Controller-Two"
  
  Scenario: Displaying Model Errors Through Nested Attributes
    Given I have a rails application
    And I run "rails g scaffold project name:string"
    And I run "rails g scaffold task project_id:integer name:string"
    And I setup the database
    And I save the following as "app/models/task.rb":
    """
    class Task < ActiveRecord::Base
      belongs_to :project
      validates_presence_of :name
    end
    """
    And I save the following as "app/models/project.rb":
    """
    class Project < ActiveRecord::Base
      has_many :tasks
      accepts_nested_attributes_for :tasks
    end
    """
    And I save the following as "app/controllers/projects_controller.rb":
    """
    class ProjectsController < ApplicationController
      def index
        @project = Project.new(
          :name => "Project",
          :tasks_attributes => [
            {:name => "Task One"},
            {:name => ""}
          ]
        )
        
        @project.valid?
      end
    end
    """
    And I save the following as "app/views/projects/index.html.erb":
    """
      <%= message_block :on => :project %>
    """
    And I start the rails application
    When I go to the projects page
    Then show me the page
    Then I should see "Tasks name can't be blank"
  
