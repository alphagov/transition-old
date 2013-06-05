module OrganisationsHelper

  def render_organisation_title(organisation)
    content_tag :h1, id: organisation.abbr, class: "organisation #{organisation.css if organisation.css.present?}" do
      link_to content_tag(:span, organisation.title), organisation
    end
  end
end
