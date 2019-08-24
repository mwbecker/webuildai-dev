require "application_system_test_case"

class CategoricalDataOptionsTest < ApplicationSystemTestCase
  setup do
    @categorical_data_option = categorical_data_options(:one)
  end

  test "visiting the index" do
    visit categorical_data_options_url
    assert_selector "h1", text: "Categorical Data Options"
  end

  test "creating a Categorical data option" do
    visit categorical_data_options_url
    click_on "New Categorical Data Option"

    fill_in "Data range", with: @categorical_data_option.data_range_id
    fill_in "Option value", with: @categorical_data_option.option_value
    click_on "Create Categorical data option"

    assert_text "Categorical data option was successfully created"
    click_on "Back"
  end

  test "updating a Categorical data option" do
    visit categorical_data_options_url
    click_on "Edit", match: :first

    fill_in "Data range", with: @categorical_data_option.data_range_id
    fill_in "Option value", with: @categorical_data_option.option_value
    click_on "Update Categorical data option"

    assert_text "Categorical data option was successfully updated"
    click_on "Back"
  end

  test "destroying a Categorical data option" do
    visit categorical_data_options_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Categorical data option was successfully destroyed"
  end
end
