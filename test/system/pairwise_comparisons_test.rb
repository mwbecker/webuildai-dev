# frozen_string_literal: true

require 'application_system_test_case'

class PairwiseComparisonsTest < ApplicationSystemTestCase
  setup do
    @pairwise_comparison = pairwise_comparisons(:one)
  end

  test 'visiting the index' do
    visit pairwise_comparisons_url
    assert_selector 'h1', text: 'Pairwise Comparisons'
  end

  test 'creating a Pairwise comparison' do
    visit pairwise_comparisons_url
    click_on 'New Pairwise Comparison'

    fill_in 'Choice', with: @pairwise_comparison.choice
    fill_in 'Participant', with: @pairwise_comparison.participant_id
    fill_in 'Scenario 1', with: @pairwise_comparison.scenario_1
    fill_in 'Scenario 2', with: @pairwise_comparison.scenario_2
    click_on 'Create Pairwise comparison'

    assert_text 'Pairwise comparison was successfully created'
    click_on 'Back'
  end

  test 'updating a Pairwise comparison' do
    visit pairwise_comparisons_url
    click_on 'Edit', match: :first

    fill_in 'Choice', with: @pairwise_comparison.choice
    fill_in 'Participant', with: @pairwise_comparison.participant_id
    fill_in 'Scenario 1', with: @pairwise_comparison.scenario_1
    fill_in 'Scenario 2', with: @pairwise_comparison.scenario_2
    click_on 'Update Pairwise comparison'

    assert_text 'Pairwise comparison was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Pairwise comparison' do
    visit pairwise_comparisons_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Pairwise comparison was successfully destroyed'
  end
end
