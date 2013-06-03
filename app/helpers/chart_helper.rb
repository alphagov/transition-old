module ChartHelper

  def summation_line_for_label(label, data, max_count, chart_height, title_prefix)
    count = (data[label] || []).inject(0) {|sum, total| sum + total.count }
    height =
      if max_count > 0
        (count * chart_height) / max_count
      else
        0
      end
    content_tag(:li, count, class: label, style: "height: #{height}px", title: "#{title_prefix} #{label} #{count}")
  end

end
