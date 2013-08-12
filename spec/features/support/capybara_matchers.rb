RSpec::Matchers.define :have_an_iframe_for do |expected_url_src|
  match do |actual|
    actual.should have_xpath("//iframe[@src='#{expected_url_src}']")
  end
end

RSpec::Matchers.define :have_readonly_select do |name|
  match do |page|
    page.should have_xpath("//select[@name='#{name}' and @readonly='readonly']")
  end
end

RSpec::Matchers.define :have_non_readonly_select do |name|
  match do |page|
    page.should have_xpath("//select[@name='#{name}' and not(@readonly)]")
  end
end