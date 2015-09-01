module LinksHelper
	def link_error_messages!
		return '' if @link.errors.empty?

		messages = @link.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
		html = <<-HTML
		<div class="alert alert-error alert-danger"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end