module UrlsHelper
  def destiny_button(url, destiny)
    button_tag(
        destiny.to_s.titleize,
        name: 'destiny',
        class: "#{url.workflow_state == destiny ? 'selected ' : ''}#{destiny}",
        value: destiny
    )
  end
end
