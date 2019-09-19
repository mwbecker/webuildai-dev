# frozen_string_literal: true

json.extract! data_range, :id, :feature_id, :is_categorical, :lower_bound, :upper_bound, :created_at, :updated_at
json.url data_range_url(data_range, format: :json)
