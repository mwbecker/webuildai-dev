# frozen_string_literal: true

require 'test_helper'

class RankedListControllerTest < ActionDispatch::IntegrationTest
  test 'should get ranked_list' do
    get ranked_list_ranked_list_url
    assert_response :success
  end
end
