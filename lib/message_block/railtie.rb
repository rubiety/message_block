module MessageBlock
  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      initializer "message_block.insert_helpers" do
        ActiveSupport.on_load(:action_view) do
          MessageBlock::Railtie.insert
        end
      end
      
      rake_tasks do
        load "tasks/message_block.rake"
      end
    end
  end
  
  class Railtie
    def self.insert
      ActionView::Base.send(:include, MessageBlock::Helpers)
    end
  end
end
