module MessageBlock
  class Engine < Rails::Engine
    initializer "message_block.insert_helpers" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send(:include, MessageBlock::Helpers)
      end
    end
  end
end
