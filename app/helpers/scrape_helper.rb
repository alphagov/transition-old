module ScrapeHelper

  def scrape_field_and_label(field, scrape_result)
    field_name = "scrape_result[#{field.name}]"
    html = label_tag(field_name, field.name.capitalize)
    html += case field.type.to_sym
    when :string
      text_field_tag(field_name, scrape_result.field_value(field.name))
    when :text
      text_area_tag(field_name, scrape_result.field_value(field.name))
    end
    html
  end
end