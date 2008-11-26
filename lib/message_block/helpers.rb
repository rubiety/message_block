module Rubiety
  module MessageBlock
    module Helpers
      
      def message_block(options = {})
        options.assert_valid_keys(:on, :model_error_type, :flash_types, :html, :id, :class)
        
        options[:model_error_type] ||= :error
        options[:flash_types] ||= [:back, :confirm, :error, :info, :warn]
        options[:on] ||= controller.controller_name.split('/').last.gsub(/\_controller$/, '').singularize.to_sym
        options[:html] ||= {:id => 'message_block'}
        options[:html][:id] = options[:id] if options[:id]
        options[:html][:class] = options[:class] if options[:class]
        
        flash_messages = {}
        
        options[:flash_types].each do |type|
          entries = flash[type.to_sym]
          next if entries.nil?
          entries = [entries] unless entries.is_a?(Array)
          
          flash_messages[type.to_sym] ||= []
          flash_messages[type.to_sym] += entries
        end
        
        options[:on] = [options[:on]] unless options[:on].is_a?(Array)
        
        options[:on] = [options[:on]] unless options[:on].is_a?(Array)
        model_objects = options[:on].map do |model_object|
          if model_object.instance_of?(String) or model_object.instance_of?(Symbol)
            instance_variable_get("@#{model_object}")
          else
            model_object
          end
        end.select {|m| !m.nil? }
        
        model_errors = model_objects.inject([]) {|b, m| b += m.errors.full_messages }
        
        flash_messages[options[:model_error_type].to_sym] ||= []
        flash_messages[options[:model_error_type].to_sym] += model_errors
        
        contents = flash_messages.keys.select {|type| !flash_messages[type.to_sym].empty? }.map do |type|
          content_tag(:ul, flash_messages[type.to_sym].map {|message| content_tag(:li, message) }.join, :class => type)
        end.join
        
        content_tag(:div, contents, options[:html])
      end
      
    end
  end
end
