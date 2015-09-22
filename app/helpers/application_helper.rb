module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Singlelink.me"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  class ActionDispatch::Request #rails 2: ActionController::Request
	  def remote_ip
	    '1.2.3.4'
	  end
	end
end
