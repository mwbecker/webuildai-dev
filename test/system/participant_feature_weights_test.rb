require "application_system_test_case"

class ParticipantFeatureWeightsTest < ApplicationSystemTestCase
  setup do
    @participant_feature_weight = participant_feature_weights(:one)
  end

  test "visiting the index" do
    visit participant_feature_weights_url
    assert_selector "h1", text: "Participant Feature Weights"
  end

  test "creating a Participant feature weight" do
    visit participant_feature_weights_url
    click_on "New Participant Feature Weight"

    fill_in "Feature", with: @participant_feature_weight.feature_id
    fill_in "Participant", with: @participant_feature_weight.participant_id
    fill_in "Weight", with: @participant_feature_weight.weight
    click_on "Create Participant feature weight"

    assert_text "Participant feature weight was successfully created"
    click_on "Back"
  end

  test "updating a Participant feature weight" do
    visit participant_feature_weights_url
    click_on "Edit", match: :first

    fill_in "Feature", with: @participant_feature_weight.feature_id
    fill_in "Participant", with: @participant_feature_weight.participant_id
    fill_in "Weight", with: @participant_feature_weight.weight
    click_on "Update Participant feature weight"

    assert_text "Participant feature weight was successfully updated"
    click_on "Back"
  end

  test "destroying a Participant feature weight" do
    visit participant_feature_weights_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Participant feature weight was successfully destroyed"
  end
end
