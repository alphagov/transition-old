module HelperMethods

  def should_have_table(selector, arr, index = nil)
    selector = all(selector)[index] if index.present?

    within selector do
      arr.each_with_index do |row, row_idx|
        row.each_with_index do |expected_text, cell_idx|
          xpath = "tr[#{row_idx + 1}]/*[not (contains(@class, 'hidden'))][#{cell_idx + 1}]"
          elem = find(:xpath, xpath)
          if expected_text != '*'
            # need to use xpath if we're in a js test in order to have waiting applied
            # Xpath doesn't appear to handle a forward slash so we're cheating
            if page.driver.class == Capybara::Poltergeist::Driver and elem.text.exclude?('/')
              page.should have_xpath(xpath, text: expected_text)
            else
              "'#{elem.text.strip}' for element '#{xpath}'".should == expected_text unless elem.text.strip.gsub(/(\n*\s{2,})/, " ") == expected_text.to_s.strip
            end
          end
        end
      end

      # check number of rows are as expected
      if arr.size == 0
        page.should have_no_xpath('tr')
      else  
        page.should have_xpath('tr', count: arr.size)
      end
    end
  end

  def should_have_list(selector, arr)
    within selector do
      arr.each_with_index do |expected_text, line_idx|
        xpath = "li[#{line_idx + 1}]"
        elem = find(:xpath, xpath)
        "'#{elem.text.strip}' for element '#{xpath}'".should == expected_text unless elem.text.strip.gsub(/(\n*\s{2,})/, " ") == expected_text.to_s.strip
      end

      # check number of rows are as expected
      if arr.size == 0
        page.should have_no_xpath('li')
      else  
        page.should have_xpath('li', count: arr.size)
      end
    end
  end
end

RSpec.configuration.include HelperMethods, type: :feature
