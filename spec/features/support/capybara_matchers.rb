RSpec::Matchers.define :have_an_iframe_at do |expected_url_src|
  match do |actual|
    actual.should have_xpath("//iframe[@src='#{expected_url_src}']")
  end
end