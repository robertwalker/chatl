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

  # OpenID assist bar (mode is one of :signup or :login)
  def open_id_link_bar(mode)
    content_tag(:div, :id => "open_id_assist_bar") do
      link_to_known_open_id(:google, mode) + " | " +
      link_to_known_open_id(:google_profile, mode) + " | " +
      link_to_known_open_id(:yahoo, mode) + " | " +
      link_to_known_open_id(:aol, mode) + " | " +
      link_to_known_open_id(:myopenid, mode) + " | " +
      link_to_known_open_id(:verisign, mode) + " | " +
      link_to_known_open_id(:wordpress, mode) + " | " +
      link_to_known_open_id(:blogger, mode)
    end
  end

  private
  def link_to_known_open_id(provider, mode)
    options = {:shared_url => false}

    case provider
    when :google
      options[:placehoder_url] = "https://www.google.com/accounts/o8/id"
      options[:range] = 0..options[:placehoder_url].length
      options[:shared_url] = true
      options[:link_text] = "Google"
    when :google_profile
      options[:placehoder_url] = "http://www.google.com/profiles/<username>"
      options[:range] = 31..40
      options[:link_text] = "Google Profile"
    when :yahoo
      options[:placehoder_url] = "http://yahoo.com/"
      options[:range] = 0..options[:placehoder_url].length
      options[:shared_url] = true
      options[:link_text] = "Yahoo!"
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
      options[:link_text] = "VeriSign PIP"
    when :wordpress
      options[:placehoder_url] = "http://<username>.wordpress.com/"
      options[:range] = 7..16
      options[:link_text] = "WordPress"
    when :blogger
      options[:placehoder_url] = "http://<username>.blogspot.com/"
      options[:range] = 7..16
      options[:link_text] = "Blogger"
    end

    js_func = "openIDUsing('#{options[:placehoder_url]}', "
    js_func << "'#{mode}', #{options[:shared_url]}, "
    js_func << "#{options[:range].begin}, #{options[:range].end});"
    js_func << " return false;"

    content_tag(:span) do
      content_tag(:a, :href => "#", :onclick => js_func) do
        options[:link_text]
      end
    end
  end
end
