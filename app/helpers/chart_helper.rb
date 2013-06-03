module ChartHelper

  def summation_line_for_label(label, data, max_count, chart_height, title_prefix)
    count = count_data_for_label(label, data)
    height =
      if max_count > 0
        (count * chart_height) / max_count
      else
        0
      end
    content_tag(:li, count, class: label, style: "height: #{height}px", title: "#{title_prefix} #{label} #{count}")
  end

  def count_data_for_label(label, data)
    (data[label] || []).inject(0) { |sum, x| sum + x.count }
  end


end
