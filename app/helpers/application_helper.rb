module ApplicationHelper
  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      content_tag(:li, :class => "active") do
        link_to(text, link)
      end
    else
      content_tag(:li) do
        link_to(text, link)
      end
    end
  end

  def human_datetime(date)
    if date
      if date.today?
        date.strftime("%l:%M%P - today")
      else
        date.strftime("%l:%M%P - %e %b")
      end
    else
      ""
    end
  end

  def days_until_launch(organisation)
    words = distance_of_time_in_words(Date.today, organisation.launch_date)
    if Date.today < organisation.launch_date
      "#{words} until launch"
    elsif Date.today == organisation.launch_date
      "launch today"
    else
      "#{words} since launch"
    end
  end
end
