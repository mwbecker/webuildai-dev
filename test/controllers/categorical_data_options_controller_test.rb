# frozen_string_literal: true

require 'test_helper'

class CategoricalDataOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @categorical_data_option = categorical_data_options(:one)
  end

  test 'should get index' do
    get categorical_data_options_url
    assert_response :success
  end

  test 'should get new' do
    get new_categorical_data_option_url
    assert_response :success
  end

  test 'should create categorical_data_option' do
    assert_difference('CategoricalDataOption.count') do
      post categorical_data_options_url, params: { categorical_data_option: { data_range_id: @categorical_data_option.data_range_id, option_value: @categorical_data_option.option_value } }
    end

    assert_redirected_to categorical_data_option_url(CategoricalDataOption.last)
  end

  test 'should show categorical_data_option' do
    get categorical_data_option_url(@categorical_data_option)
    assert_response :success
  end

  test 'should get edit' do
    get edit_categorical_data_option_url(@categorical_data_option)
    assert_response :success
  end

  test 'should update categorical_data_option' do
    patch categorical_data_option_url(@categorical_data_option), params: { categorical_data_option: { data_range_id: @categorical_data_option.data_range_id, option_value: @categorical_data_option.option_value } }
    assert_redirected_to categorical_data_option_url(@categorical_data_option)
  end

  test 'should destroy categorical_data_option' do
    assert_difference('CategoricalDataOption.count', -1) do
      delete categorical_data_option_url(@categorical_data_option)
    end

    assert_redirected_to categorical_data_options_url
  end
end
