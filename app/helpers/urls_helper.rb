module UrlsHelper
  def destiny_button(destiny)
    button_tag(destiny.to_s.titleize, name: 'destiny', class: destiny, value: destiny)
  end
end
