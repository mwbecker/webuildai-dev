# frozen_string_literal: true

json.extract! categorical_data_option, :id, :data_range_id, :option_value, :created_at, :updated_at
json.url categorical_data_option_url(categorical_data_option, format: :json)
