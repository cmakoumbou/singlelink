module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="ui negative message">
      <i class="close icon"></i>
      <ul class="list">
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end
end