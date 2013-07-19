module UrlsHelper
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

  def entry_for_content_type(content_type)
    [
      content_type.subtype || content_type.type,
      content_type.id,
      {
        'data-user_need_required' => content_type.user_need_required,
        'data-scrapable'          => content_type.scrapable
      }
    ]
  end

  def grouped_options_for_content_type_select(url)
    ContentType.all.group_by(&:type).map do |type, content_types|
      if content_types.one? && (content_type = content_types.first).subtype.blank?
        options_for_select([entry_for_content_type(content_type)], url.content_type_id)
      else
        grouped_options_for_select({ type => content_types.map { |content_type| entry_for_content_type(content_type) } }, url.content_type_id)
      end
    end.join.html_safe
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
