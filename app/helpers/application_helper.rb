# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tab_class_for(base_uri)
    if request.request_uri.starts_with?("/#{base_uri}")
      'tab selected_tab'
    else
      'tab'
    end
  end

  def render_textile(textile)
    RedCloth.new(textile).to_html
  end
end
