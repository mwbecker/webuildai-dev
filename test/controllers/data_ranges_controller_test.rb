# frozen_string_literal: true

require 'test_helper'

class DataRangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_range = data_ranges(:one)
  end

  test 'should get index' do
    get data_ranges_url
    assert_response :success
  end

  test 'should get new' do
    get new_data_range_url
    assert_response :success
  end

  test 'should create data_range' do
    assert_difference('DataRange.count') do
      post data_ranges_url, params: { data_range: { feature_id: @data_range.feature_id, is_categorical: @data_range.is_categorical, lower_bound: @data_range.lower_bound, upper_bound: @data_range.upper_bound } }
    end

    assert_redirected_to data_range_url(DataRange.last)
  end

  test 'should show data_range' do
    get data_range_url(@data_range)
    assert_response :success
  end

  test 'should get edit' do
    get edit_data_range_url(@data_range)
    assert_response :success
  end

  test 'should update data_range' do
    patch data_range_url(@data_range), params: { data_range: { feature_id: @data_range.feature_id, is_categorical: @data_range.is_categorical, lower_bound: @data_range.lower_bound, upper_bound: @data_range.upper_bound } }
    assert_redirected_to data_range_url(@data_range)
  end

  test 'should destroy data_range' do
    assert_difference('DataRange.count', -1) do
      delete data_range_url(@data_range)
    end

    assert_redirected_to data_ranges_url
  end
end
