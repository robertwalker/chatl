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

  def address_formatter(addressable)
    h(addressable.street_address.gsub(/\n/, "<br />"))
  end

  def city_state_zip_formatter(addressable)
    h(addressable.city) + ", " + h(addressable.state) + " &nbsp;" + h(addressable.zip)
  end

  def open_id_link_bar
    content_tag(:div) do
      link_to_known_open_id(:google) +
      " | " +
      link_to_known_open_id(:yahoo) +
      " | " +
      link_to_known_open_id(:aol) +
      " | " +
      link_to_known_open_id(:myopenid) +
      " | " +
      link_to_known_open_id(:verisign) +
      " | " +
      link_to_known_open_id(:wordpress) +
      " | " +
      link_to_known_open_id(:blogger)
    end
  end

  private
  def link_to_known_open_id(provider)
    options = {}

    case provider
    when :google
      options[:js_function] = "signupUsingGoogle()"
      options[:link_text] = "Google"
    when :yahoo
      options[:js_function] = "signupUsingYahoo()"
      options[:link_text] = "Yahoo"
    when :aol
      options[:placehoder_url] = "http://openid.aol.com/<screenname>"
      options[:range] = 22..33
      options[:link_text] = "AOL"
    when :myopenid
      options[:placehoder_url] = "http://<username>.myopenid.com/"
      options[:range] = 7..16
      options[:link_text] = "myOpenID"
    when :verisign
      options[:placehoder_url] = "http://<username>.pip.verisignlabs.com/"
      options[:range] = 7..16
      options[:link_text] = "Verisign PIP"
    when :wordpress
      options[:placehoder_url] = "http://<username>.wordpress.com/"
      options[:range] = 7..16
      options[:link_text] = "WordPress"
    when :blogger
      options[:placehoder_url] = "http://<username>.blogspot.com/"
      options[:range] = 7..16
      options[:link_text] = "Blogger"
    end

    if options[:js_function]
      js_func = "#{options[:js_function]};"
    else
      js_func = "signupUsingOpenID('#{options[:placehoder_url]}', "
      js_func << "#{options[:range].begin}, #{options[:range].end});"
    end
    js_func << " return false;"

    content_tag(:span) do
      content_tag(:a, :href => "#", :onclick => js_func) do
        options[:link_text]
      end
    end
  end
end
