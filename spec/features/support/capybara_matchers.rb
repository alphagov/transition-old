RSpec::Matchers.define :have_an_iframe_for do |expected_url_src|
  match do |actual|
    actual.should have_xpath("//iframe[@src='#{expected_url_src}']")
  end
end

RSpec::Matchers.define :have_list_in_this_order do |selector, list|
  match do |page|
    within selector do
      list.each_with_index do |expected_text, line_idx|
        xpath = "li[#{line_idx + 1}]"
        elem = find(:xpath, xpath)
        "'#{elem.text.strip}' for element '#{xpath}'".should == expected_text unless elem.text.strip.gsub(/(\n*\s{2,})/, " ") == expected_text.to_s.strip
      end

      # check number of rows are as expected
      if list.empty?
        page.should have_no_xpath('li')
      else
        page.should have_xpath('li', count: list.size)
      end
    end
  end
end