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
    page.should have_no_xpath("//select[@name='#{name}' and @readonly='readonly']")
  end
end

module CapybaraExtension
  def has_list_in_this_order?(selector, list)
    within selector do
      list.each_with_index do |expected_text, line_idx|
        xpath = "li[#{line_idx + 1}]"
        elem = find(:xpath, xpath)
        "'#{elem.text.strip}' for element '#{xpath}'".should == expected_text unless elem.text.strip.gsub(/(\n*\s{2,})/, " ") == expected_text.to_s.strip
      end

      # check number of rows are as expected
      if list.empty?
        has_no_xpath?('li').should == true
      else
        has_xpath?('li', count: list.size).should == true
      end
    end
  end

  def has_exact_table?(selector, arr)
    within selector do
      arr.each_with_index do |row, row_idx|
        row.each_with_index do |expected_text, cell_idx|
          xpath = "tr[#{row_idx + 1}]/*[not (contains(@class, 'hidden'))][#{cell_idx + 1}]"
          elem = find(:xpath, xpath)
          if expected_text != '*'
            # need to use xpath if we're in a js test in order to have waiting applied
            # Xpath doesn't appear to handle a forward slash so we're cheating
            if driver.class == Capybara::Poltergeist::Driver and elem.text.exclude?('/')
              has_xpath?(xpath, text: expected_text).should == true
            else
              "'#{elem.text.strip}' for element '#{xpath}'".should == expected_text unless elem.text.strip.gsub(/(\n*\s{2,})/, " ") == expected_text.to_s.strip
            end
          end
        end
      end

      # check number of rows are as expected
      if arr.size == 0
        has_no_xpath?('tr').should == true
      else  
        has_xpath?('tr', count: arr.size).should == true
      end
    end
  end
end

Capybara::Session.send(:include, CapybaraExtension) 