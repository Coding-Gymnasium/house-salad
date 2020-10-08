require 'rails_helper'


feature "user can search for house members" do

  scenario "user submits valid state name" do

    json_response = File.read('spec/fixtures/members_of_the_house.json')

    stub_request(:get, "https://api.propublica.org/congress/v1/members/house/CO/current.json").
      with( headers: { 'X-Api-Key'=> ENV["PROPUBLICA_API_KEY"] }).to_return(status: 200, body: json_response)

    # As a user
    # When I visit "/"
    visit '/'

    select "Colorado", from: :state
    click_on "Locate Members of the House"

    expect(current_path).to eq(search_path)
    expect(page).to have_content("7 Results")
    expect(page).to have_css(".member", count: 7)

    within(first(".member")) do
      expect(page).to have_css(".name")
      name = find(".name").text
      expect(name).to_not be_empty

      expect(page).to have_css(".role")
      role = find(".role").text
      expect(role).to_not be_empty

      expect(page).to have_css(".party")
      party = find(".party").text
      expect(party).to_not be_empty

      expect(page).to have_css(".district")
      district = find(".district").text
      expect(district).to_not be_empty
    end

  end
end
