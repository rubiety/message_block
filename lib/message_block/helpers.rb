module MessageBlock
  module Helpers
    
    def message_block(options = {})
      options[:model_error_type] ||= :error
      options[:flash_types] ||= [:notice, :back, :confirm, :error, :info, :warn].sort_by(&:to_s)
      options[:on] ||= controller.controller_name.split('/').last.gsub(/\_controller$/, '').singularize.to_sym
      options[:html] ||= {:id => "message_block", :class => "message_block"}
      options[:html][:id] = options[:id] if options[:id]
      options[:html][:class] = options[:class] if options[:class]
      options[:container] = :div if options[:container].nil?
      
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
        if model_object == :all
          assigns.values.select {|o| o.respond_to?(:errors) && o.errors.is_a?(ActiveModel::Errors) }
        elsif model_object.instance_of?(String) or model_object.instance_of?(Symbol)
          instance_variable_get("@#{model_object}")
        else
          model_object
        end
      end.flatten.select {|m| !m.nil? }
      
      model_errors = model_objects.inject([]) {|b, m| b += m.errors.full_messages }
      
      flash_messages[options[:model_error_type].to_sym] ||= []
      flash_messages[options[:model_error_type].to_sym] += model_errors
      
      contents = flash_messages.keys.sort_by(&:to_s).select {|type| !flash_messages[type.to_sym].empty? }.map do |type|
        "<ul class=\"#{type}\">" + flash_messages[type.to_sym].map {|message| "<li>#{message}</li>" }.join + "</ul>"
      end.join
      
      if options[:container]
        content_tag(options[:container], contents, options[:html], false)
      else
        contents
      end
    end
    
  end
end
