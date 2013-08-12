require 'features/features_helper'

feature 'View, create, edit and delete user needs' do
  background do
    login_as_stub_user
    organisation1 = create :organisation, title: 'Department for International Department',  abbr: 'DFID'
    organisation2 = create :organisation, title: 'Department for Business, Innovation and Skills', abbr: 'BIS'
    @user_need = create :user_need, name: 'Project overview', organisation: organisation1,
     as_a: 'Agent', i_want_to: 'Improve customer service', so_that: 'Tax payers are happy'
  end

  scenario 'Edit a user need', js: true do
    visit root_path
    click_link 'User needs'

    page.should have_xpath("//option[text()='Project overview (DFID) ##{@user_need.needotron_id}']")
    page.should_not have_link('Edit')

    select 'Project overview'
    page.should have_content 'Agent'
    page.should have_content 'Improve customer service'
    page.should have_content 'Tax payers are happy'
    click_link 'Edit'

    page.should have_xpath('//option[text()="Department for International Department" and @selected="selected"]')
    page.should have_field('Name', with: 'Project overview')
    page.should have_field('As a', with: 'Agent')
    page.should have_field('I want to', with: 'Improve customer service')
    page.should have_field('So that', with: 'Tax payers are happy')

    select 'Department for Business, Innovation and Skills'
    fill_in 'Name', with: 'Mission'
    click_button 'Save'

    page.should have_xpath("//option[text()='Mission (BIS) ##{@user_need.needotron_id}']")
  end

  scenario 'Create a new user need' do
    visit user_needs_path

    select 'Department for Business, Innovation and Skills', from: 'Organisation'
    fill_in('Name', with: 'Passport renewal')
    fill_in('As a', with: "Agent on her Majesty's secret service")
    fill_in('I want to', with: "Ski and run")
    fill_in('So that', with: "I stay fit")
    click_button 'Save'

    # User needs dropdown should contain the new need
    page.should have_select('user_need_id', options: ['', "Passport renewal (BIS) ##{UserNeed.last.needotron_id}", 
      "Project overview (DFID) ##{@user_need.needotron_id}"])

    # Organisation should be remembered
    page.find('#user_need_organisation_id').
      should have_selected_option('Department for Business, Innovation and Skills')
  end

  scenario 'Delete a user need' do
    visit edit_user_need_path(@user_need)

    click_link 'Delete'

    page.should have_select('user_need_id', options: [''])
  end
end
