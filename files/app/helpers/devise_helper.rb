module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
    resource.errors.full_messages.map { |msg| content_tag(:div, msg, class: 'alert alert-danger', role: 'alert') }.join.html_safe
  end
end
