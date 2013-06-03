module HttpStatusHelper

  def for_each_http_status_category(&block)
    ["error", "gone", "redirect", "ok"].reverse.each(&block)
  end

  def categorize_http_status(http_status)
    if http_status =~ /^2/
      "ok"
    elsif http_status == "301"
      "redirect"
    elsif http_status == "410"
      "gone"
    else
      "error"
    end
  end

  def grouped_by_http_status_category(data)
    data.group_by { |x| categorize_http_status(x.http_status) }
  end
end
