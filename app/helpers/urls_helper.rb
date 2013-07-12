module UrlsHelper
  ##
  # Create a button for destiny
  def destiny_button(url, destiny)
    button_tag(
        destiny.to_s.titleize,
        name: 'destiny',
        class: "#{url.workflow_state == destiny ? 'selected ' : ''}#{destiny}",
        value: destiny
    )
  end

  ##
  # Create a link classed to URL workflow state, or text if current
  def classy_link(url, current_url)
    link_to_if(
        url != current_url,
        url.url,
        site_url_path(current_url.site, url),
        { title: url.url, class: (url.workflow_state) }
    )
  end

  ##
  # Create a named-for-this-controller-only dropdown for urls from the given collection
  def content_type_select(content_types)
    collection_select :url, :content_type, content_types, :id, :to_s
  end
end
