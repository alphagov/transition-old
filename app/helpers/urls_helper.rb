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
    content_tag :select, name: 'url[content_type]' do
      options_for_select(
        content_types.each_with_index.map do |type, index|
          has_succeeding_types = content_types[index + 1].andand.type == type.type
          klass = case
                    when type.subtype.blank? && has_succeeding_types; 'optgroup'
                    when type.subtype.present?;                       'subtype'
                  end

          opts = { 'data-scrape' => type.scrapable }
          opts[:class] = klass if klass

          [type, type.id, opts]
        end
      )
    end
  end
end
