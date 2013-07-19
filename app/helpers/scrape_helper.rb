module ScrapeHelper

  def scrape_field_and_label(field, scrape_result)
    field_name = "scrape_result[#{field.name}]"
    html = label_tag(field_name, field.name.capitalize)
    html += case field.type.to_sym
    when :string
      text_field_tag(field_name, scrape_result.field_value(field.name))
    when :text
      rich_text_editor_toolbar + text_area_tag(field_name, scrape_result.field_value(field.name), id: 'wysihtml5-textarea')
    end
    html
  end

  def rich_text_editor_toolbar
    %Q{
      <span id="wysihtml5-toolbar" style="display: none;">
        <a data-wysihtml5-action="change_view" href="javascript:;" unselectable="on" class="wysihtml5-action-active">html view</a>
      </span>
    }.html_safe
  end
end