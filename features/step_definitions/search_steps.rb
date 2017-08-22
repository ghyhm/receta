Given(/^there are the following recipies$/) do |table|
  table.hashes.each do |recipe|
    Recipe.create!(name: recipe[:name])
  end
end

When(/^user goes to recipes page$/) do
  visit '/'
end

When(/^user searches recipe with keyword "([^"]*)"$/) do |keyword|
  fill_in 'keywords', with: keyword.to_s
  click_on 'Search'
  # save_and_open_page
  # page.save_screenshot('screenshot.png')
end

Then(/^the following recipes are shown$/) do |table|
  # save_and_open_screenshot
  table.hashes.each do |recipe|
    expect(page).to have_content(recipe[:name])
  end
end
