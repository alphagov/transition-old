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

  def grouped_options_for_url_group_select(url)
    options = {}
    UrlGroupType.all.each do |group_type|
      options[group_type.name] = group_type.url_groups.for_organisation(url.site.organisation).map {|url_group| [url_group.name, url_group.id]}
    end
    grouped_options_for_select(options, url.url_group_id)
  end

  # optgroup and options for user needs where needs are grouped by the given url's organisation and then all other organisations' user needs
  def grouped_options_for_user_needs_group_select(url)
    options = {}
    options[url.site.organisation.title] = url.site.organisation.user_needs.map {|user_need| [user_need.name, user_need.id]}
    options['Other'] = UserNeed.where('organisation_id <> ? or organisation_id is null', url.site.organisation.id).map {|user_need| [user_need.name, user_need.id]}
    grouped_options_for_select(options, url.user_need_id)
  end
end
