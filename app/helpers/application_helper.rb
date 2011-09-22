module ApplicationHelper
  
  def error_messages(target, wrap = true)
    html = ""
    html += %(<div id="errorExplanation">) if wrap
    html += %(<p><b>Oh snap! You got an error!</b> Change the following <i>#{pluralize(target.errors.count, "error")}</i> and try again.</p>)
    html += %(<ul>)
    target.errors.full_messages.each do |msg|
      html += %(<li>#{msg}</li>)
    end
    html += %(</ul>)
    html += %(</div>) if wrap
    html
  end
  alias_method :error_messages_for, :error_messages
  
end
