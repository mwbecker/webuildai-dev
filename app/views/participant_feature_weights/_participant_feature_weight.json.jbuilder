# frozen_string_literal: true

json.extract! participant_feature_weight, :id, :participant_id, :feature_id, :weight, :created_at, :updated_at
json.url participant_feature_weight_url(participant_feature_weight, format: :json)
