# frozen_string_literal: true

json.extract! scenario, :id, :group_id, :feature_id, :feature_value, :created_at, :updated_at
json.url scenario_url(scenario, format: :json)
