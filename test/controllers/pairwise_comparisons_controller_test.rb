require 'test_helper'

class PairwiseComparisonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pairwise_comparison = pairwise_comparisons(:one)
  end

  test "should get index" do
    get pairwise_comparisons_url
    assert_response :success
  end

  test "should get new" do
    get new_pairwise_comparison_url
    assert_response :success
  end

  test "should create pairwise_comparison" do
    assert_difference('PairwiseComparison.count') do
      post pairwise_comparisons_url, params: { pairwise_comparison: { choice: @pairwise_comparison.choice, participant_id: @pairwise_comparison.participant_id, scenario_1: @pairwise_comparison.scenario_1, scenario_2: @pairwise_comparison.scenario_2 } }
    end

    assert_redirected_to pairwise_comparison_url(PairwiseComparison.last)
  end

  test "should show pairwise_comparison" do
    get pairwise_comparison_url(@pairwise_comparison)
    assert_response :success
  end

  test "should get edit" do
    get edit_pairwise_comparison_url(@pairwise_comparison)
    assert_response :success
  end

  test "should update pairwise_comparison" do
    patch pairwise_comparison_url(@pairwise_comparison), params: { pairwise_comparison: { choice: @pairwise_comparison.choice, participant_id: @pairwise_comparison.participant_id, scenario_1: @pairwise_comparison.scenario_1, scenario_2: @pairwise_comparison.scenario_2 } }
    assert_redirected_to pairwise_comparison_url(@pairwise_comparison)
  end

  test "should destroy pairwise_comparison" do
    assert_difference('PairwiseComparison.count', -1) do
      delete pairwise_comparison_url(@pairwise_comparison)
    end

    assert_redirected_to pairwise_comparisons_url
  end
end
