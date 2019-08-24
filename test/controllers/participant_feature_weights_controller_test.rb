require 'test_helper'

class ParticipantFeatureWeightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participant_feature_weight = participant_feature_weights(:one)
  end

  test "should get index" do
    get participant_feature_weights_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_feature_weight_url
    assert_response :success
  end

  test "should create participant_feature_weight" do
    assert_difference('ParticipantFeatureWeight.count') do
      post participant_feature_weights_url, params: { participant_feature_weight: { feature_id: @participant_feature_weight.feature_id, participant_id: @participant_feature_weight.participant_id, weight: @participant_feature_weight.weight } }
    end

    assert_redirected_to participant_feature_weight_url(ParticipantFeatureWeight.last)
  end

  test "should show participant_feature_weight" do
    get participant_feature_weight_url(@participant_feature_weight)
    assert_response :success
  end

  test "should get edit" do
    get edit_participant_feature_weight_url(@participant_feature_weight)
    assert_response :success
  end

  test "should update participant_feature_weight" do
    patch participant_feature_weight_url(@participant_feature_weight), params: { participant_feature_weight: { feature_id: @participant_feature_weight.feature_id, participant_id: @participant_feature_weight.participant_id, weight: @participant_feature_weight.weight } }
    assert_redirected_to participant_feature_weight_url(@participant_feature_weight)
  end

  test "should destroy participant_feature_weight" do
    assert_difference('ParticipantFeatureWeight.count', -1) do
      delete participant_feature_weight_url(@participant_feature_weight)
    end

    assert_redirected_to participant_feature_weights_url
  end
end
