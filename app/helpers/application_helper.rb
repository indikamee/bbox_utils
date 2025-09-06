require 'qr_utils'


module ApplicationHelper
    include QrUtils
    
    def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice
      "alert-success"
    when :alert, :error
      "alert-danger"
    when :warning
      "alert-warning"
    else
      "alert-info"
    end
  end
    
      def flash_messages(_opts = {})
        flash.each do |msg_type, message|
          if message.is_a? Array
            #message.each do |msg|
            #  render_msg(msg_type,msg)
            #end
            render_msg(msg_type,safe_join(message,('<br/>').html_safe))
          else  
            render_msg(msg_type,message)
          end
        end
        nil
      end
    
      def render_msg(msg_type, message)
        concat(content_tag(:div, class: "alert #{bootstrap_class_for_flash(msg_type)} alert-dismissible fade show", role: "alert") do
          concat(content_tag(:button, class: "btn-close", data: {bs_dismiss: 'alert'}, aria: {label: 'Close'}) do
          end)
          concat message
        end)
      end

end
