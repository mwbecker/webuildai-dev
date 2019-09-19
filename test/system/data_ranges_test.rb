# frozen_string_literal: true

require 'application_system_test_case'

class DataRangesTest < ApplicationSystemTestCase
  setup do
    @data_range = data_ranges(:one)
  end

  test 'visiting the index' do
    visit data_ranges_url
    assert_selector 'h1', text: 'Data Ranges'
  end

  test 'creating a Data range' do
    visit data_ranges_url
    click_on 'New Data Range'

    fill_in 'Feature', with: @data_range.feature_id
    check 'Is categorical' if @data_range.is_categorical
    fill_in 'Lower bound', with: @data_range.lower_bound
    fill_in 'Upper bound', with: @data_range.upper_bound
    click_on 'Create Data range'

    assert_text 'Data range was successfully created'
    click_on 'Back'
  end

  test 'updating a Data range' do
    visit data_ranges_url
    click_on 'Edit', match: :first

    fill_in 'Feature', with: @data_range.feature_id
    check 'Is categorical' if @data_range.is_categorical
    fill_in 'Lower bound', with: @data_range.lower_bound
    fill_in 'Upper bound', with: @data_range.upper_bound
    click_on 'Update Data range'

    assert_text 'Data range was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Data range' do
    visit data_ranges_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Data range was successfully destroyed'
  end
end
