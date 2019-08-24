require "application_system_test_case"

class ScenariosTest < ApplicationSystemTestCase
  setup do
    @scenario = scenarios(:one)
  end

  test "visiting the index" do
    visit scenarios_url
    assert_selector "h1", text: "Scenarios"
  end

  test "creating a Scenario" do
    visit scenarios_url
    click_on "New Scenario"

    fill_in "Feature", with: @scenario.feature_id
    fill_in "Feature value", with: @scenario.feature_value
    fill_in "Group", with: @scenario.group_id
    click_on "Create Scenario"

    assert_text "Scenario was successfully created"
    click_on "Back"
  end

  test "updating a Scenario" do
    visit scenarios_url
    click_on "Edit", match: :first

    fill_in "Feature", with: @scenario.feature_id
    fill_in "Feature value", with: @scenario.feature_value
    fill_in "Group", with: @scenario.group_id
    click_on "Update Scenario"

    assert_text "Scenario was successfully updated"
    click_on "Back"
  end

  test "destroying a Scenario" do
    visit scenarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Scenario was successfully destroyed"
  end
end
