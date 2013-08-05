require 'features/features_helper'

feature 'View, create or edit content types' do
  background do
    login_as_stub_user
  end

  describe :index_edit do
    let!(:content_type1) { create :content_type, type: 'Type 1', subtype: 'Subtype 1', scrapable: true, 
                                  user_need_required: false, mandatory_guidance: false }
    let!(:content_type2) { create :content_type, type: 'Type 2', subtype: nil, scrapable: false, 
                                  user_need_required: true, mandatory_guidance: true }
  
    scenario 'Visit the contents page and swap the order of the two contents type', js: true do
      visit admin_root_path
      click_link 'Content types'

      page.should have_exact_table 'table thead', [
        ['Type / Subtype', 'Scrapable?', 'User need required?', 'Mandatory guidance?', '']]
      page.should have_exact_table 'table tbody', [
        ['Type 1 / Subtype 1', 'Yes',    '',    '', ''],
        ['Type 2',                '', 'Yes', 'Yes', '']]

      drop_place = find('table tbody tr:nth-child(2) td:nth-child(1) a')
      find('table tbody tr:nth-child(1) td:nth-child(1) a').drag_to(drop_place)

      # reload page to check that re-ordering has occurred
      visit admin_content_types_path
      page.should have_exact_table 'table tbody', [
        ['Type 2',                '', 'Yes', 'Yes', ''],
        ['Type 1 / Subtype 1', 'Yes',    '',    '', '']]
    end

    scenario 'Edit a content type' do
      visit admin_content_types_path
      click_link 'Type 1 / Subtype 1'

      page.should have_field('Type', with: 'Type 1')
      page.should have_field('Subtype', with: 'Subtype 1')
      page.should have_checked_field('Scrapable')
      page.should have_unchecked_field('User need required')
      page.should have_unchecked_field('Mandatory guidance')

      fill_in 'Type', with: 'Type 1 mod'
      fill_in 'Subtype', with: 'Subtype 1 mod'
      uncheck 'Scrapable'
      check 'User need required'
      check 'Mandatory guidance'

      click_button 'Save'

      page.current_path.should == admin_content_types_path
      page.should have_content("Content type 'Type 1 mod / Subtype 1 mod' saved")
      page.should have_exact_table 'table tbody', [
        ['Type 1 mod / Subtype 1 mod', '', 'Yes', 'Yes', ''],
        ['Type 2',                     '', 'Yes', 'Yes', '']]
    end
  end

  describe :create do
    scenario 'Create a new content type' do
      visit admin_content_types_path
      click_link 'New content type'

      fill_in('Type', with: 'New type')
      click_button 'Save'

      page.should have_content("Content type 'New type' saved")
      page.should have_exact_table 'table tbody', [
        ['New type', '', '', '']]
    end
  end
end
