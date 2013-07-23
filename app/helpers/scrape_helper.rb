module ScrapeHelper

  def scrape_field_and_label(field, scrape_result)
    field_name = "scrape_result[#{field.name}]"

    html = label_tag(field_name, field.name.humanize)
    html += if field.type.to_sym == :string
      text_field_tag(field_name, scrape_result.field_values[field.name])
    elsif field.type.to_sym == :date
      text_field_tag(field_name, scrape_result.field_values[field.name], class: 'datepicker')
    elsif field.type.to_sym == :text and field.name == 'body'
      rich_text_editor_toolbar + text_area_tag(field_name, scrape_result.field_values[field.name])
    elsif field.type.to_sym == :text
      text_area_tag(field_name, scrape_result.field_values[field.name])
    end
    html
  end

  def rich_text_editor_toolbar
    %Q{
      <span id="wysihtml5-toolbar" style="display: none;">
        <a data-wysihtml5-command="bold"></a>
        <a data-wysihtml5-command="italic"></a>
        <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1"></a>
        <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2"></a>
        <a data-wysihtml5-command="createLink"></a>
        <div data-wysihtml5-dialog="createLink" style="display: none;">
          <label>Link:<input data-wysihtml5-dialog-field="href" value="http://" class="text"></label>
          <a data-wysihtml5-dialog-action="save">OK</a> <a data-wysihtml5-dialog-action="cancel">Cancel</a>
        </div>
        <a data-wysihtml5-action="change_view" href="javascript:;" unselectable="on" class="wysihtml5-action-active"></a>
      </span>
    }.html_safe
  end
end