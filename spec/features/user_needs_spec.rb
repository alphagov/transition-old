require 'features/features_helper'

feature 'View, create, edit and delete user needs' do
  background do
    login_as_stub_user
    organisation1 = create :organisation, title: 'DFID'
    organisation2 = create :organisation, title: 'BIS'
    @user_need = create :user_need, name: 'Project overview', organisation: organisation1,
     as_a: 'Agent', i_want_to: 'Improve customer service', so_that: 'Tax payers are happy'
  end

  scenario 'Edit a user need', js: true do
    visit root_path
    click_link 'User needs'

    page.should have_xpath('//optgroup[@label="DFID"]/option[text()="Project overview"]')
    page.should_not have_link('Edit')

    select 'Project overview'
    page.should have_content 'Agent'
    page.should have_content 'Improve customer service'
    page.should have_content 'Tax payers are happy'
    click_link 'Edit'

    page.should have_xpath('//option[text()="DFID" and @selected="selected"]')
    page.should have_field('Name', with: 'Project overview')

    select 'BIS'
    fill_in 'Name', with: 'Mission'
    click_button 'Save'

    page.should have_xpath('//optgroup[@label="BIS"]/option[text()="Mission"]')
  end

  scenario 'Create a new user need' do
    visit user_needs_path

    select 'BIS', from: 'Organisation'
    fill_in('Name', with: 'Passport renewal')
    fill_in('As a', with: "Agent on her Majesty's secret service")
    fill_in('I want to', with: "Ski and run")
    fill_in('So that', with: "I stay fit")
    click_button 'Save'

    page.should have_xpath('//optgroup[@label="BIS"]/option[text()="Passport renewal"]')
  end

  scenario 'Delete a user need' do
    visit edit_user_need_path(@user_need)

    click_link 'Delete'

    page.should have_no_xpath('//optgroup[@label="DFID"]/option[text()="Project overview"]')
  end
end
